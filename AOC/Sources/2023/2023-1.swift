//
//  DayOne.swift
//  AOC
//
//  Created by Bas Buijsen on 01/12/2023.
//

import Foundation

func dayOne23(input: [String], partTwo: Bool) -> Int {
    let numberString = ["one": "o1e", "two": "t2o", "three": "th3ee", "four": "f4or", "five": "fi5e", "six": "s6x", "seven": "se7en", "eight": "ei8ht", "nine": "ni9e"]
    
    let replacedStrings: [String] = if partTwo {
        input.compactMap { value in numberString.reduce(value, { $0.replacingOccurrences(of: $1.key, with: $1.value)}) }
    } else { input }
    return replacedStrings.compactMap { value in Int("\(value.first(where: { $0.isNumber })!)\(value.last(where: { $0.isNumber })!)") }.reduce(0, +)
}
