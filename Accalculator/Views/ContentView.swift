//
//  ContentView.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedCalculator: CalculatorType = .regular
    
    var body: some View {
        VStack {
            // Menu selector
            Picker("Calculator", selection: $selectedCalculator) {
                ForEach(CalculatorType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Display the selected calculator
            switch selectedCalculator {
            case .regular:
                RegularCalculator()
            case .conversion:
                ConvertCalculator()
            case .tips:
                TipsCalculator()
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
