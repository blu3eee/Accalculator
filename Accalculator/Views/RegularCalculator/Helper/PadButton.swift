//
//  Button.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/8/24.
//

import SwiftUI

struct PadButton: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var visibleWorkings: String
    var cell: String
    var buttonPressed: (String) -> Void
    
    let buttonWidth: CGFloat = 60
    let buttonHeight: CGFloat = 50
    let buttonCornerRadius: CGFloat = 20 // Half of width or height for a circle
    
    let operators = ["÷", "+", "×", "-"]
    
    var body: some View {
        Button(action: {buttonPressed(cell)}, label: {
            buttonCellText(cell: cell)
                .foregroundColor(buttonTextColor(cell))
                .font(.system(size: buttonCellFontSize(), weight: .medium))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        })
        .background(buttonColor(cell))
        .cornerRadius(buttonCornerRadius)
        .padding(.vertical, buttonPadding())
    }
    
    let orangeCells = ["=","÷", "+", "×", "-", "%"]
    let grayCells = ["⌦","AC"]
    func buttonTextColor(_ cell: String) -> Color {
        if (orangeCells.contains(cell) || grayCells.contains(cell)) {
            return Color(UIColor.darkText)
        }
        
        if let isNumber = cell.last?.isNumber, isNumber {
            if cell.count == 1 {
                return Color(UIColor.darkText)
            }
        }
        
        return Color(UIColor.label)
    }
    
    func buttonColor(_ cell: String) -> Color {
        if(orangeCells.contains(cell)) {
            return .orange
        }
        
        if(grayCells.contains(cell)) {
            return .gray
        }
        
        if let isNumber = cell.last?.isNumber, isNumber {
            if cell.count == 1 {
                return Color(UIColor.lightGray)
            }
        }
        
        return Color(UIColor.secondarySystemBackground)
    }
    
    // Example function for demonstration
    func buttonCellText(cell: String) -> some View {
        let exponents = ["x^2", "x^3", "x^y", "e^x"]
        
        if exponents.contains(cell) {
            // Handle exponent cases
            if cell == "x^2" {
                return AnyView(Text("x²"))
            } else if cell == "x^3" {
                return AnyView(Text("x³"))
            } else if cell == "x^y" {
                // Dynamic exponent, assuming y is provided
                return AnyView(HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("x")
                    Text("y")
                        .font(.system(size: 18))
                        .baselineOffset(8)
                })
            } else if cell == "e^x" {
                return AnyView(HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("e")
                    Text("x")
                        .font(.system(size: 18))
                        .baselineOffset(8)
                })
            }
        } else if cell == "sqrt" {
            // Handle AC or C based on `visibleWorkings`
            return AnyView(Text("√(x)"))
        } else if cell == "AC" {
            // Handle AC or C based on `visibleWorkings`
            return AnyView(Text(visibleWorkings.isEmpty ? "AC" : "C")) // Example color
        }
        return AnyView(Text(cell))
    }
    
    func buttonCellFontSize() -> CGFloat {
        if horizontalSizeClass == .compact && verticalSizeClass == .regular { 40 } else { 22 }
    }
    
    func buttonPadding() -> CGFloat {
        if horizontalSizeClass == .compact && verticalSizeClass == .regular { 7 } else { 0 }
    }
}
