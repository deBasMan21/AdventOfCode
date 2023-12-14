//
//  2023-13.swift
//  AOC
//
//  Created by Bas Buijsen on 14/12/2023.
//

import Foundation

func dayThirteen23(input: [String], partTwo: Bool) -> Int {
    let grids = input.compactMap { $0.split(separator: "\n").compactMap { $0.split(separator: "").compactMap(String.init) } }
    return grids.enumerated().compactMap { index, grid in
        let rotatedGrid = grid.first!.enumerated().compactMap { index, _ in grid.compactMap { $0[index] } }
        return if let verticalMirror = partTwo ? findSmudges(grid: rotatedGrid) : findMirror(grid: rotatedGrid) { verticalMirror }
        else if let horizontalMirror = partTwo ? findSmudges(grid: grid) : findMirror(grid: grid) { horizontalMirror * 100 }
        else { 0 }
    }.reduce(0, +)
}

func findMirror(grid: [[String]]) -> Int? {
    let duplicateLineIndices = grid.enumerated().flatMap { index, line in
        grid.enumerated().compactMap { mirrorIndex, comparator in
            return if comparator == line && index != mirrorIndex && abs(index - mirrorIndex) % 2 == 1 {
                (min(index, mirrorIndex), max(index, mirrorIndex))
            } else { nil }
        }
    }
    
    return duplicateLineIndices.compactMap { duplicateLineIndex in
        let lowerIndex = Int(floor(Double(duplicateLineIndex.0 + duplicateLineIndex.1) / 2))
        return (0...lowerIndex).allSatisfy { index in
            let lowerBound = lowerIndex - index
            let higherBound = lowerIndex + 1 + index
            return !(higherBound < grid.count && grid[lowerBound] != grid[higherBound])
        } ? lowerIndex + 1 : nil
    }.first
}

func findSmudges(grid: [[String]]) -> Int? {
    (0...grid.count - 2).compactMap {
        let left = grid[0...$0].reversed()
        let right = Array(grid[$0 + 1...grid.count - 1])
        return zip(left, right).flatMap({ zip($0.0, $0.1).compactMap { $0.0 != $0.1 ? 1 : 0 } }).reduce(0, +) == 1 ? $0 + 1 : nil
    }.first
}
