//
//  CalculatorType.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//

enum CalculatorType: String, CaseIterable, Identifiable {
    case regular = "Regular"
    case conversion = "Conversion"
    case tips = "Tips & Split"

    var id: String { self.rawValue }
}

