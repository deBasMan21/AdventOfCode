//
//  2023-9.swift
//  AOC
//
//  Created by Bas Buijsen on 09/12/2023.
//

import Foundation

func dayNine23(input: [String], partTwo: Bool) -> Int {
    return input.compactMap { $0.split(separator: " ").compactMap { Int($0) } }.compactMap { line in
        var diffLines: [[Int]] = [line]
        while diffLines.last?.allSatisfy({ $0 == diffLines.last!.first }) != true {
            diffLines.append(diffLines.last!.enumerated().compactMap { index, number in
                if (partTwo && index == diffLines.last!.count - 1) || (!partTwo && index == 0) { return nil }
                return (number - diffLines.last![partTwo ? (index + 1) : (index - 1)])
            })
        }
        return diffLines.reversed().compactMap { partTwo ? $0.first : $0.last }.reduce(0, +)
    }.reduce(0, +)
}
