//
//  2023-6.swift
//  AOC
//
//  Created by Bas Buijsen on 06/12/2023.
//

import Foundation

func daySix23(input: [String], partTwo: Bool) -> Double {
    let splitInput = if partTwo { input.compactMap { $0.split(separator: ":").compactMap { $0.replacing(" ", with: "")} } }
        else { input.compactMap { $0.split(separator: " ").filter { !$0.isEmpty} } }
    return Array(splitInput.first!.enumerated()).suffix(from: 1).compactMap { Race(time: Int($1)!, distance: Int(splitInput.last![$0])!) }.compactMap { $0.calculateTimeAndDistance() }.reduce(1, *)
}

struct Race {
    let time, distance: Int
    
    func calculateTimeAndDistance() -> Double {
        calculateValue(operatorFunc: -, rounded: ceil) - calculateValue(operatorFunc: +, rounded: floor) - 1
    }
    
    private func calculateValue(operatorFunc: (Double, Double) -> Double, rounded: (Double) -> Double) -> Double {
        rounded(-1 * operatorFunc(Double(time * -1), sqrt(Double((pow(Decimal(time), 2) as NSDecimalNumber).intValue - (4 * distance)))) / 2)
    }
}
