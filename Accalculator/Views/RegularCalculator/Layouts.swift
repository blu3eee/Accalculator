//
//  Layouts.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/8/24.
//

import Foundation

func displayWorkings(workings: String) -> String {
    return workings
        .replacingOccurrences(of: " ", with: "")
        .replacingOccurrences(of: "exp", with: "e**")
        .replacingOccurrences(of: "sqrt", with: "√")
}
