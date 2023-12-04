//
//  2023-3.swift
//  AOC
//
//  Created by Bas Buijsen on 03/12/2023.
//

import Foundation

fileprivate let adjacentIndices: [(Double, Double)] = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]

func dayThree23(input: [String], partTwo: Bool) -> Int {
    let grid = input.compactMap { $0.split(separator: "").compactMap { String($0) } }
    var currentNumber = ""
    var isAdjacentToSymbol = false
    var numbers: [Int] = []
    var gearsMap: [CGPoint: [Int]] = [:]
    var gears: Set<CGPoint> = Set()
    
    grid.enumerated().forEach { index, row in
        row.enumerated().forEach { rowIndex, item in
            if item.firstIsNumber {
                currentNumber += item
                isAdjacentToSymbol = isAdjacentToSymbol || hasAdjacentSymbols(grid: grid, index: index, rowIndex: rowIndex)
                
                let adjacentGears = hasAdjacentGear(grid: grid, index: index, rowIndex: rowIndex)
                adjacentGears.forEach { gears.insert($0) }
            } else {
                if !currentNumber.isEmpty {
                    if isAdjacentToSymbol {
                        numbers.append(Int(currentNumber)!)
                    }
                    if gears.count > 0 {
                        gears.forEach {
                            var currentList = gearsMap[$0] ?? []
                            currentList.append(Int(currentNumber)!)
                            gearsMap[$0] = currentList
                        }
                    }
                    currentNumber = ""
                    isAdjacentToSymbol = false
                    gears = Set()
                }
            }
        }
    }
    
    return if partTwo {
        gearsMap.compactMap { key, value in
            value.count == 2 ? value.reduce(1, *) : 0
        }.reduce(0, +)
    } else {
        numbers.reduce(0, +)
    }
}

func hasAdjacentSymbols(grid: [[String]], index: Int, rowIndex: Int) -> Bool {
    return adjacentIndices.contains(where: { (y, x) in
        guard let value = grid[safe: index + Int(y)]?[safe: rowIndex + Int(x)] else { return false }
        return !value.firstIsNumber && value != "."
    })
}

func hasAdjacentGear(grid: [[String]], index: Int, rowIndex: Int) -> [CGPoint] {
    return adjacentIndices.compactMap { (y, x) in
        return if let value = grid[safe: index + Int(y)]?[safe: rowIndex + Int(x)], value == "*" {
             CGPoint(x: Double(rowIndex) + x, y: Double(index) + y)
        } else { nil }
    }
}
