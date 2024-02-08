//
//  RegularCalculator.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//

import SwiftUI

struct RegularCalculator: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    let grid = [
        ["AC", "⌦", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", "()", ".", "="]
    ]
    
    let landscapeGrids = [
        ["x^2", "x^3", "AC", "⌦", "%", "÷"],
        ["sinh", "cosh", "7", "8", "9", "×"],
        ["sin", "cos", "4", "5", "6", "-"],
        ["tan", "cot", "1", "2", "3", "+"],
        ["(", ")", "0", "()", ".", "="]
    ]
    
    let operators = ["÷", "+", "×", "-"]
    
    @State var visibleWorkings = ""
    @State var visibleResults = ""
    @State var showAlert = false
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // Portrait orientation layout
                portraitLayout
            } else {
                // Landscape orientation layout
                landscapeLayout
            }
        }
        .background(Color(UIColor.systemBackground).ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Input"),
                message: Text(visibleWorkings),
                dismissButton: .default(Text("Okay"))
            )
        }
    }
    
    private var portraitLayout: some View {
        VStack(spacing: 0) {
            // current expression
            HStack {
                Spacer()
                Text(visibleWorkings.isEmpty ? "0" : visibleWorkings.replacingOccurrences(of: " ", with: ""))
                    .padding()
                    .foregroundColor(Color(UIColor.label))
                    .font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity).fixedSize(horizontal: false, vertical: true)
            // current result
            HStack {
                Spacer()
                Text(visibleResults.isEmpty ? "0" : visibleResults)
                    .padding()
                    .foregroundColor(Color(UIColor.label))
                    .font(.system(size: 50, weight: .medium))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            // calculator pads
            Spacer()
            Spacer()
            ForEach(grid, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self)  {cell in
                        Button(action: {buttonPressed(cell: cell)}, label: {
                            Text(cell == "AC" ? (visibleWorkings.isEmpty ? cell : "C") : cell)
                                .foregroundColor(buttonTextColor(cell))
                                .font(.system(size: 40, weight: .medium))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                        .background(buttonColor(cell))
                        .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
    
    // Assuming "Width" to be sufficient to accommodate the longest text
    // You might need to adjust this based on your font size and content
    let buttonWidth: CGFloat = 60
    let buttonHeight: CGFloat = 50
    let buttonCornerRadius: CGFloat = 20 // Half of width or height for a circle
    
    
    private var landscapeLayout: some View {
        HStack(spacing: 0) {
            VStack {
                // current expression
                HStack {
                    Spacer()
                    Text(visibleWorkings.isEmpty ? "0" : visibleWorkings.replacingOccurrences(of: " ", with: ""))
                        .padding()
                        .foregroundColor(Color(UIColor.label))
                        .font(.system(size: 30, weight: .heavy))
                }.frame(maxWidth: .infinity, maxHeight: .infinity).fixedSize(horizontal: false, vertical: true)
                // current result
                HStack {
                    Spacer()
                    Text(visibleResults.isEmpty ? "0" : visibleResults)
                        .padding()
                        .foregroundColor(Color(UIColor.label))
                        .font(.system(size: 50, weight: .medium))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // calculator pads
            Spacer()
            VStack {
                ForEach(landscapeGrids, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self)  {cell in
                            Button(action: {buttonPressed(cell: cell)}, label: {
                                Text(cell == "AC" ? (visibleWorkings.isEmpty ? cell : "C") : cell)
                                    .foregroundColor(buttonTextColor(cell))
                                    .font(.system(size: 22, weight: .medium))
                                    .frame(width: buttonWidth, height: buttonHeight)
                                    .background(buttonColor(cell))
                            })
                            .background(buttonColor(cell))
                            .cornerRadius(buttonCornerRadius)
                        }
                    }
                }
                
            }
        }
    }
    
    func buttonPressed(cell: String) {
        if operators.contains(cell) {
            if visibleWorkings != "" {
                visibleWorkings += " " + cell + " "
            }
            return
        }
        switch cell {
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
                if (!validInput()) {
                    showAlert = true
                    return
                }
                visibleWorkings = " ( " + visibleWorkings + " ) ÷ 100"
            }
        case "()":
            if !visibleWorkings.isEmpty {
                if (!validInput()) {
                    showAlert = true
                    return
                }
                visibleWorkings = " ( " + visibleWorkings + " ) "
            }
        case "x^2":
            if !visibleWorkings.isEmpty {
                if (!validInput()) {
                    showAlert = true
                    return
                }
                visibleWorkings = " ( " + visibleWorkings + " ) ** 2"
            }
        case "x^3":
            if !visibleWorkings.isEmpty {
                if (!validInput()) {
                    showAlert = true
                    return
                }
                visibleWorkings = " ( " + visibleWorkings + " ) ** 3"
            }
        case "sin", "cos", "tan", "cot", "sinh", "cosh":
            if !visibleWorkings.isEmpty {
                if (!validInput()) {
                    showAlert = true
                    return
                }
                visibleWorkings = cell + " ( " + visibleWorkings + " ) "
            }
        default:
            visibleWorkings += cell
        }
    }
    
    func calculateResult() {
        // This function should parse and evaluate `visibleWorkings`
        // Then update `visibleResults` with the calculation result
        if(validInput()) {
            var workings = visibleWorkings.replacingOccurrences(of: "÷", with: "/")
            workings = workings.replacingOccurrences(of: "×", with: "*")
            
            // Attempt to evaluate the expression safely
            let expression = NSExpression(format: ensureFloatingPoint(workings: workings))
            if let result = expression.expressionValue(with: nil, context: nil) as? Double {
                // Successfully evaluated the expression
                visibleResults = formatResult(val: result)
            } else {
                // Expression evaluation failed, show alert
                showAlert = true
            }
            return
        }
        showAlert = true
    }
    
    func buttonTextColor(_ cell: String) -> Color {
        if(cell == "AC" || cell == "⌦") {
            return Color(UIColor.darkText)
        }
        
        return Color(UIColor.label)
    }
    
    func buttonColor(_ cell: String) -> Color {
        if(cell == "AC" || cell == "⌦") {
            return .orange
        }
        
        return Color(UIColor.secondarySystemBackground)
    }
    
    func validInput() -> Bool {
        if visibleWorkings.isEmpty {
            return false
        }
        let workings = ensureFloatingPoint(workings: visibleWorkings)
        
        let openBrackets = workings.filter { $0 == "(" }.count
        let closeBrackets = workings.filter { $0 == ")" }.count
        if openBrackets != closeBrackets {
            return false // Unbalanced brackets
        }
        
        var previousCharacter: Character? = nil
        var foundInvalidSequence = false
        
        for character in workings {
            if let prev = previousCharacter {
                // Check for invalid sequences like "(*", "(+", or "7+)"
                if (operators.contains(String(prev)) || String(prev) == "%") && (character == ")" || operators.contains(String(character))) {
                    foundInvalidSequence = true
                    break
                }
                if prev == "(" && (character == ")" || operators.contains(String(character))) {
                    foundInvalidSequence = true
                    break
                }
            }
            previousCharacter = character
        }
        
        if foundInvalidSequence {
            return false // Found invalid operator sequence
        }
        
        if operators.contains(String(workings.last!)) || workings.last! == "-" {
            return false // Ends with an operator
        }
        
        if workings.first! == ")" || workings.last! == "(" {
            return false // Starts with closing or ends with opening parenthesis
        }
        
        return true
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
}

#Preview {
    RegularCalculator()
}
