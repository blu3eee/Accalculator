//
//  DoubleExtensions.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/8/24.
//

import Foundation

extension Double {
    func toDisplayString(decimalPlaces: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimalPlaces // Adjust for desired precision
        return numberFormatter.string(from: NSNumber(value: self)) ?? "Invalid"
    }
    
    func toDisplayStringNoCommas(decimalPlaces: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimalPlaces // Adjust for desired precision
        numberFormatter.groupingSeparator = "" // No grouping separator for thousands
        return numberFormatter.string(from: NSNumber(value: self)) ?? "Invalid"
    }
}
