//
//  ConvertCalculator.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//

import SwiftUI

struct ConvertCalculator: View {
    @State var selectedConversion = ConversionType.temperature
    @State var inputUnit = "Celsius"
    @State var outputUnit = "Fahrenheit"
    @State var inputValue = "1"
    @State var outputValue = "33.8"
    
    var body: some View {
        VStack {
            Picker("Conversion Type", selection: $selectedConversion) {
                ForEach(ConversionType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedConversion, {updateConversionType()})
            
            
            HStack {
                // Picker for the input unit on the left
                Picker("Input Unit", selection: $inputUnit) {
                    ForEach(selectedConversion.units, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: inputUnit, {updateConversion()})
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
                
                Spacer() // This pushes the button towards the center
                
                // Button for swapping units in the middle
                Button(action: {
                    swap(&inputUnit, &outputUnit)
                }) {
                    Image(systemName: "arrow.left.arrow.right")// Using a system image for better visual
                        .clipShape(Circle()) // Makes the button circular
                }
                
                Spacer() // This pushes the next picker towards the right
                
                // Picker for the output unit on the right
                Picker("Output Unit", selection: $outputUnit) {
                    ForEach(selectedConversion.units, id: \.self) {
                        Text($0)
                    }
                }
                .onChange(of: outputUnit, {updateConversion()})
                .pickerStyle(MenuPickerStyle())
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            HStack {
                TextField("0", text: $inputValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .onChange(of: inputValue, {updateConversion()})
                Spacer()
                Text("=")
                Spacer()
                Text("\(outputValue)").frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
    
    func updateConversionType() {
        let selectedConversionValue = selectedConversion;
        
        switch selectedConversionValue {
        case .temperature:
            inputUnit = "Celsius"
            outputUnit = "Fahrenheit"
        case .length:
            inputUnit = "Meters"
            outputUnit = "Feet"
        case .time:
            inputUnit = "Hours"
            outputUnit = "Seconds"
        case .volume:
            inputUnit = "Liters"
            outputUnit = "Gallons"
        }
        
    }
    
    func updateConversion() {
        guard let _value = Double(inputValue) else {
            if !inputValue.isEmpty {
                outputValue = "Invalid"
            } else {
                outputValue = ""
            }
            return
        }
        
        // Handle empty inputValue by treating it as 0
        let inputValueDouble = Double(inputValue) ?? 0.0
        
        if inputUnit == outputUnit {
            // If the units are the same, return the inputValue, or "0" if it was empty
            outputValue = inputValue.isEmpty ? "0" : inputValue
            return
        }
        
        if let result = convertInputValue(inputValueDouble: inputValueDouble) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 10 // Adjust for desired precision
            outputValue = numberFormatter.string(from: NSNumber(value: result)) ?? "Invalid"
        } else {
            outputValue = "Conversion not supported"
        }
    }
    
    
    func convertInputValue(inputValueDouble: Double) -> Double? {
        let selectedConversionValue = selectedConversion
        let result: Double?
        
        switch selectedConversionValue {
        case .temperature:
            result = convertTemperature(inputValue: inputValueDouble)
        case .length:
            result = convertUnit(value: inputValueDouble, using: lengthRates, through: "Meters")
        case .time:
            result = convertUnit(value: inputValueDouble, using: timeRates, through: "Seconds")
        case .volume:
            result = convertUnit(value: inputValueDouble, using: volumeRates, through: "Liters")
        }
        
        return result
    }
    
    func convertTemperature(inputValue: Double) -> Double? {
        switch (inputUnit, outputUnit) {
        case ("Celsius", "Fahrenheit"):
            return inputValue * 9 / 5 + 32
        case ("Celsius", "Kelvin"):
            return inputValue + 273.15
        case ("Fahrenheit", "Celsius"):
            return (inputValue - 32) * 5 / 9
        case ("Fahrenheit", "Kelvin"):
            return (inputValue + 459.67) * 5 / 9
        case ("Kelvin", "Celsius"):
            return inputValue - 273.15
        case ("Kelvin", "Fahrenheit"):
            return inputValue * 9 / 5 - 459.67
        default:
            return nil
        }
    }
    
    func convertUnit(value inputValue: Double, using rates: [String: [String: Double]], through intermediateUnit: String? = nil) -> Double? {
        // Direct conversion attempt
        if let rate = rates[inputUnit]?[outputUnit] {
            return inputValue * rate
        }
        
        // If an intermediate unit is provided and applicable
        if let intermediate = intermediateUnit {
            // Convert to the intermediate unit then to the target unit
            if let toIntermediateRate = rates[inputUnit]?[intermediate], let fromIntermediateRate = rates[intermediate]?[outputUnit] {
                let intermediateValue = inputValue * toIntermediateRate
                return intermediateValue * fromIntermediateRate
            }
        } else {
            // Attempt to find a chain conversion if direct or single intermediate step is not possible
            for (intermediateUnit, _) in rates[inputUnit] ?? [:] {
                if let toIntermediateRate = rates[inputUnit]?[intermediateUnit],
                   let fromIntermediateRate = rates[intermediateUnit]?[outputUnit] {
                    let intermediateValue = inputValue * toIntermediateRate
                    return intermediateValue * fromIntermediateRate
                }
            }
        }
        
        // No conversion path found
        return nil
    }
    
}


#Preview {
    ConvertCalculator()
}
