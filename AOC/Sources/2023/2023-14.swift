//
//  2023-14.swift
//  AOC
//
//  Created by Bas Buijsen on 15/12/2023.
//

import Foundation

func dayFourteen23(input: [String], partTwo: Bool) -> Int {
    var grid = input.compactMap { $0.split(separator: "").compactMap { String($0) } }
    var grids: [[[String]]: Int] = [:]
    
    if partTwo {
        var loopIndex = -1
        var loopLength = -1
        
        for index in 0 ... 1000000000 {
            grid = (0...3).reduce(into: grid, { v, _ in v = shiftWeights(grid: rotateGrid(grid: v)) })
            
            if let firstIndex = grids[grid] {
                loopIndex = firstIndex
                loopLength = index - firstIndex
                break
            }
            grids[grid] = index
        }
        
        let sortedGrids = grids.sorted(by: { $0.value < $1.value }).compactMap { $0.key }
        grid = rotateGrid(grid: sortedGrids[((1000000000 - loopIndex) % loopLength) + loopIndex - 1])
    } else {
        grid = shiftWeights(grid: rotateGrid(grid: grid))
    }
    return grid.reduce(into: 0, { $0 += $1.enumerated().compactMap { $1 == "O" ? $0 + 1 : nil }.reduce(0, +) })
}

func rotateGrid(grid: [[String]]) -> [[String]] {
    grid.first!.enumerated().compactMap { index, _ in grid.reversed().compactMap { $0[index] } }
}

func shiftWeights(grid: [[String]]) -> [[String]] {
    return grid.enumerated().reduce(into: grid, { newGrid, value in
        value.element.enumerated().reversed().forEach { lineIndex, item in
            guard item == "O" else { return }
            for loopingIndex in lineIndex...newGrid[value.offset].count {
                if newGrid[value.offset][safe: loopingIndex + 1] != "." {
                    newGrid[value.offset][lineIndex] = "."
                    newGrid[value.offset][loopingIndex] = "O"
                    break
                }
            }
        }
    })
}
