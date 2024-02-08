//
//  TipsCalculator.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//

import SwiftUI

struct TipsCalculator: View {
    @State private var inputTotalBill = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 18
    
    // Tip percentages for the picker
    private let tipPercentages = [0, 10, 15, 18, 20, 22, 25, 50, 100]
    
    private var totalPerPerson: Double {
        calculateTotalPerPerson(tipPercentage: Double(tipPercentage))
    }
    
    private var totalWithTip: Double {
        calculateTotalWithTip(tipPercentage: Double(tipPercentage))
    }
    
    private func calculateTotalPerPerson(tipPercentage: Double) -> Double {
        let peopleCount = Double(numberOfPeople)
        let orderAmount = Double(inputTotalBill) ?? 0
        let tipValue = orderAmount / 100 * tipPercentage
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    private func calculateTotalWithTip(tipPercentage: Double) -> Double {
        let orderAmount = Double(inputTotalBill) ?? 0
        let tipValue = orderAmount / 100 * tipPercentage
        return orderAmount + tipValue
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Enter your bill details")) {
                    HStack {
                        Text("Bill total")
                        Spacer()
                        TextField("Enter bill total", text: $inputTotalBill)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Number of People")
                        Spacer()
                        Text("\(numberOfPeople)")
                            .frame(alignment: .center)
                        Stepper("", value: $numberOfPeople, in: 1...100).labelsHidden()
                    }
                    
                    HStack {
                        Text("Tip percentage")
                        Spacer()
                        Picker("Tip percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) { percentage in
                                Text("\(percentage)%")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: 100, maxHeight: 100)
                        .clipped()
                        .labelsHidden()
                    }
                }
                
                Section(header: Text("Results")) {
                    HStack {
                        Text("Total per person")
                        Spacer()
                        Text("$\(totalPerPerson, specifier: "%.2f")")
                    }
                    
                    HStack {
                        Text("Total bill (with tip)")
                        Spacer()
                        Text("$\(totalWithTip, specifier: "%.2f")")
                    }.foregroundColor(Color(.orange))
                }
                
                Section(header: Text("Tip Variations")) {
                    let currentIndex = tipPercentages.firstIndex(of: tipPercentage) ?? tipPercentages.count / 2
                    let prevIndex = currentIndex - 1 >= 0 ? currentIndex - 1 : nil
                    let nextIndex = currentIndex + 1 < tipPercentages.count ? currentIndex + 1 : nil
                    
                    let indices = [prevIndex, Optional(currentIndex), nextIndex].compactMap { $0 }
                    
                    HStack {
                        
                        ForEach(indices, id: \.self) { index in
                            let tip = tipPercentages[index]
                            let totalPerPerson = calculateTotalPerPerson(tipPercentage: Double(tip))
                            let totalWithTip = calculateTotalWithTip(tipPercentage: Double(tip))
                            Spacer()
                            VStack {
                                Text("\(tip)% Tip")
                                Text("$\(totalPerPerson, specifier: "%.2f")")
                                Text("$\(totalWithTip, specifier: "%.2f")").foregroundColor(Color(.orange))
                            }.scaledToFit()
                            Spacer()
                        }
                        
                    }.multilineTextAlignment(.center)
                }
            }
        }
    }
}

#Preview {
    TipsCalculator()
}
