//
//  ConversionType.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//

enum ConversionType: String, CaseIterable, Identifiable {
    case temperature = "Temperature"
    case length = "Length"
    case time = "Time"
    case volume = "Volume"
    
    var id: String { self.rawValue }
    
    var units: [String] {
        switch self {
        case .temperature: return ["Celsius", "Fahrenheit", "Kelvin"]
        case .length: return ["Feet", "Yards", "Miles", "Meters", "Kilometers", "Centimeters", "Millimeters", "Micrometers", "Nanometers"]
        case .time: return ["Seconds", "Minutes", "Hours", "Days", "Weeks", "Months", "Years"]
        case .volume: return ["Liters", "Milliliters", "Cups", "Gallons", "Quarts", "Pints"]
        }
    }
}
