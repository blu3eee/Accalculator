//
//  StringExtensions.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/8/24.
//

import Foundation

let operators = ["÷", "+", "×", "-"]

extension String {
    func isNumber() -> Bool {
        if let isNumber = self.last?.isNumber, isNumber {
            return self.count == 1
        }
        return false
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }

        return indices
    }
    
    func ensureNSEFloatingPoint() -> String {
        // A simplistic approach to convert integers to floating point numbers by appending .0
        // Note: This is a basic implementation and might not handle all edge cases well.
        let tokens = self.split(separator: " ")
        var newWorkings = ""
        
        for token in tokens {
            if let _ = Int(token) {
                // If the token is an integer, append .0 to make it a floating point
                newWorkings += "\(token).0 "
            } else {
                // Otherwise, just append the token as it is
                newWorkings += "\(token) "
            }
        }
        
        return newWorkings.trimmingCharacters(in: .whitespaces)
    }
    
    func endsWith(values: [String]) -> Bool {
        for suffix in values {
            if self.hasSuffix(suffix) {
                return true
            }
        }
        return false
    }
    
    func isValidNSExpression() -> Bool {
            if self.isEmpty {
                return false
            }
            
            // Ensure floating point representation for integers
            let workings = self.ensureNSEFloatingPoint().replacingOccurrences(of: " ", with: "")
            
            // Define invalid suffixes that shouldn't end the expression
            let invalidSuffixes = ["**", "(", "."] + operators
            
            // Check if the expression ends with an invalid suffix or starts with a closing bracket
            if workings.endsWith(values: invalidSuffixes) || workings.first! == ")" {
                return false
            }
            
            // Check for unbalanced brackets
            let openBrackets = workings.filter { $0 == "(" }.count
            let closeBrackets = workings.filter { $0 == ")" }.count
            if openBrackets != closeBrackets {
                return false
            }
            
            // Find all indices of "**"
            let indices = workings.indicesOf(string: "**").map { self.index(self.startIndex, offsetBy: $0 + 2) }
            
            for idx in indices {
                // Ensure each index is valid and followed by a number
                if idx < workings.endIndex, let nextChar = workings[idx].unicodeScalars.first, !CharacterSet.decimalDigits.contains(nextChar) {
                    
                    return false // The character following "**" is not a number
                }
            }
            
            // Check for other invalid sequences
            var previousCharacter: Character? = nil
            var foundInvalidSequence = false
            for character in workings {
                if let prev = previousCharacter {
                    // Invalid sequence checks...
                    if (prev == ")" && character.isNumber) || (prev == "." && !character.isNumber) {
                        foundInvalidSequence = true
                        break
                    }
                }
                previousCharacter = character
            }
            
            // Ensure expression is not invalid sequence
            if foundInvalidSequence {
                return false
            }
            
            return true
        }
}
