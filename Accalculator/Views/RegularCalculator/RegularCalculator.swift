//
//  RegularCalculator.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//

import SwiftUI
import Foundation

struct RegularCalculator: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let operators = ["÷", "+", "×", "-"]
    
    @State var visibleWorkings = ""
    @State var visibleResults = ""
    @State var showAlert = false
    @State var power = false
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // Portrait orientation layout
                PortraitLayout(
                    visibleWorkings: visibleWorkings,
                    visibleResults: visibleResults,
                    power: power,
                    buttonPressed: buttonPressed
                )
            } else {
                // Landscape orientation layout
                LandscapeLayout(
                    visibleWorkings: visibleWorkings,
                    visibleResults: visibleResults,
                    power: power,
                    buttonPressed: buttonPressed
                )
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text(displayWorkings(workings: visibleWorkings)),
                dismissButton: .default(Text("Okay"))
            )
        }
    }   
    
    func buttonPressed(cell: String) {
        if operators.contains(cell) {
            if visibleWorkings != "" {
                visibleWorkings += " " + cell + " "
            }
            return
        }
        
        let isValid = visibleWorkings.isValidNSExpression()
        
        switch cell {
        case ".":
                if canAddDecimalPoint(to: visibleWorkings) {
                    visibleWorkings += cell
                } else {
                    return
                }
        case "AC":
            if visibleWorkings.isEmpty {
                visibleResults = ""
            }
            visibleWorkings = ""
        case "=":
            if !visibleWorkings.isEmpty {
                calculateResult()
            }
        case "⌦":
            if !visibleWorkings.isEmpty {
                visibleWorkings.removeLast()
            }
        case "%":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = "( " + visibleWorkings + " ) ÷ 100"
            }
        case "()":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = "( " + visibleWorkings + " ) "
            }
        case "x^2":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = "( " + visibleWorkings + " ) ** 2"
            }
        case "x^3":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = "( " + visibleWorkings + " ) ** 3"
            }
        case "x^y":
            power = !power
        case "e^x":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = "exp ( " + visibleWorkings + " ) "
            }
        case "log", "ln", "sqrt":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = cell + " ( " + visibleWorkings + " ) "
            }
        case "(", ")":
            if !visibleWorkings.isEmpty {
                visibleWorkings += cell
            }
        case "1/x":
            if !visibleWorkings.isEmpty {
                if (!isValid) {
                    showAlert = true
                    return
                }
                visibleWorkings = "1 / ( " + visibleWorkings + " ) "
            }
        default:
            if power {
                if cell.isNumber() {
                    visibleWorkings = "( " + visibleWorkings + " ) ** " + cell
                }
                power = false
                return
            }
            if visibleWorkings.replacingOccurrences(of: " ", with: "").last == ")" && cell.isNumber() {
                visibleWorkings += "*"
            }
            visibleWorkings += cell
        }
    }
    
    func calculateResult() {
        if(visibleWorkings.isValidNSExpression()) {
            var workings = visibleWorkings.replacingOccurrences(of: "÷", with: "/")
            workings = workings.replacingOccurrences(of: "×", with: "*")
            
            // Replace unsupported operations or handle them before creating NSExpression
            let formattedWorkings = ensureFloatingPoint(workings: workings)
            let expression = NSExpression(format: formattedWorkings)
            
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                visibleWorkings = result.toDisplayStringNoCommas(decimalPlaces: 10)
                visibleResults = result.toDisplayString(decimalPlaces: 10)
            } else {
                // Expression evaluation failed, show alert
                showAlert = true
            }
        } else {
            showAlert = true
        }
    }
    
    
    // this is a workaround for when NSExpression assuming we are doing Int operations
    // if there is no '.' or double number in the expression, causing decimal loss in the calculated result
    func ensureFloatingPoint(workings: String) -> String {
        // A simplistic approach to convert integers to floating point numbers by appending .0
        // Note: This is a basic implementation and might not handle all edge cases well.
        let tokens = workings.split(separator: " ")
        var newWorkings = ""
        
        for token in tokens {
            if let _ = Int(token) {
                // If the token is an integer, append .0 to make it a floating point
                newWorkings += "\(token).0 "
            } else {
                // Otherwise, just append the token as it is
                newWorkings += "\(token) "
            }
        }
        
        return newWorkings.trimmingCharacters(in: .whitespaces)
    }
    
    func formatResult(val : Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 5 // Adjust for desired precision
        return numberFormatter.string(from: NSNumber(value: val)) ?? "Invalid"
    }
    
    func canAddDecimalPoint(to expression: String) -> Bool {
        // Allow if expression is empty
        if expression.isEmpty { return true }

        // Disallow if the last character is not a number or a closing parenthesis
        guard let lastCharacter = expression.last, lastCharacter.isNumber || lastCharacter == ")" else { return false }

        // Find the last numeric component in the expression
        var lastNumericComponent = ""
        var foundNonNumeric = false
        for character in expression.reversed() {
            if character.isNumber || character == "." {
                if foundNonNumeric {
                    break
                }
                lastNumericComponent.insert(character, at: lastNumericComponent.startIndex)
            } else {
                foundNonNumeric = true
            }
        }

        // Check if the last numeric component already contains a decimal point
        if lastNumericComponent.contains(".") {
            return false
        }

        return true
    }

}

#Preview {
    RegularCalculator()
}
