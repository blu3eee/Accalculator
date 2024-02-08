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
            Picker("Calculator", selection: $selectedCalculator) {
                ForEach(CalculatorType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            TabView(selection: $selectedCalculator) {
                RegularCalculator()
                    .tag(CalculatorType.regular)
                ConvertCalculator()
                    .tag(CalculatorType.conversion)
                TipsCalculator()
                    .tag(CalculatorType.tips)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
