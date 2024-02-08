//
//  PortraitLayout.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/8/24.
//

import SwiftUI

struct PortraitLayout: View {
    var visibleWorkings: String;
    var visibleResults: String;
    var buttonPressed: (String) -> Void
    
    let grid = [
        ["AC", "⌦", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["()", "0", ".", "="]
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // current expression
            HStack {
                Text(visibleWorkings.isEmpty ? "0" : visibleWorkings.replacingOccurrences(of: " ", with: ""))
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
            // calculator pads
            Spacer()
            Spacer()
            ForEach(grid, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self)  {cell in
                        PadButton(visibleWorkings: visibleWorkings, cell: cell, buttonPressed: buttonPressed)
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }
}

struct PortraitLayout_Preview : PreviewProvider {
    static func buttonPressed(cell: String) {}
    static var previews: some View {
        PortraitLayout(visibleWorkings: "1+2", visibleResults: "3", buttonPressed: buttonPressed)
    }
}
