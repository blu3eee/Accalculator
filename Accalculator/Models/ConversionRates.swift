//
//  ConversionRates.swift
//  Accalculator
//
//  Created by Phuoc Khai Nguyen on 2/7/24.
//


let timeRates: [String: [String: Double]] = [
    "Seconds": [
        "Minutes": 1 / 60,
        "Hours": 1 / 3600,
        "Days": 1 / 86400,
        "Weeks": 1 / (86400 * 7),
        "Months": 1 / (86400 * 30.44), // Approximation
        "Years": 1 / (86400 * 365) // Approximation
    ],
    "Minutes": ["Seconds": 60],
    "Hours": ["Seconds": 3600],
    "Days": ["Seconds": 86400],
    "Weeks": ["Seconds": 604800],
    "Months": ["Seconds": 2_629_746], // Approximation
    "Years": ["Seconds": 31_556_952] // Approximation
]

let lengthRates: [String: [String: Double]] = [
    "Meters": [
        "Kilometers": 0.001,
        "Feet": 3.28084,
        "Yards": 1.09361,
        "Miles": 0.000621371,
        "Centimeters": 100,
        "Inches": 39.3701,
        "Millimeters": 1000,
        "Micrometers": 1_000_000,
        "Nanometers": 1_000_000_000,
    ],
    "Kilometers": ["Meters": 1000],
    "Feet": ["Meters": 0.3048],
    "Yards": ["Meters": 0.9144],
    "Miles": ["Meters": 1609.34],
    "Centimeters": ["Meters": 0.01],
    "Inches": ["Meters": 0.0254],
    "Millimeters": ["Meters": 0.001],
    "Micrometers": ["Meters": 1e-6],
    "Nanometers": ["Meters": 1e-9],
]

let volumeRates: [String: [String: Double]] = [
    "Liters": [
        "Milliliters": 1000,
        "Gallons": 0.264172,
        "Cups": 4.22675,
        "Quarts": 1.05669,
        "Pints": 2.11338,
    ],
    "Milliliters": ["Liters": 0.001],
    "Gallons": ["Liters": 3.78541],
    "Cups": ["Liters": 0.236588],
    "Quarts": ["Liters": 0.946353],
    "Pints": ["Liters": 0.473176],
]
