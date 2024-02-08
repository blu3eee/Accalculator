//
//  PortraitLayout.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/8/24.
//

import SwiftUI

struct LandscapeLayout: View {
    var visibleWorkings: String;
    var visibleResults: String;
    var buttonPressed: (String) -> Void
    
    let grids = [
        ["x^2", "x^3", "AC", "⌦", "%", "÷"],
        ["x^y", "e^x", "7", "8", "9", "×"],
        ["log", "ln", "4", "5", "6", "-"],
        ["1/x", "sqrt", "1", "2", "3", "+"],
        ["(", ")", "()", "0", ".", "="]
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
                // current expression
                HStack {
                    Text(visibleWorkings.isEmpty ? "0" : displayWorkings(workings: visibleWorkings))
                        .padding()
                        .foregroundColor(Color(UIColor.label))
                        .font(.system(size: 25, weight: .heavy))
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                // current result
                HStack {
                    Spacer()
                    Text(visibleResults.isEmpty ? "" : visibleResults)
                        .padding()
                        .foregroundColor(Color(UIColor.label))
                        .font(.system(size: 50, weight: .medium))
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            // calculator pads
            VStack {
                ForEach(grids, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self)  {cell in
                            PadButton(visibleWorkings: visibleWorkings, cell: cell, buttonPressed: buttonPressed)
                        }
                    }
                }
                
            }
        }
    }
}

struct LanscapeLayout_Preview : PreviewProvider {
    static func buttonPressed(cell: String) {}
    static var previews: some View {
        LandscapeLayout(visibleWorkings: "1+2", visibleResults: "3", buttonPressed: buttonPressed)
    }
}
