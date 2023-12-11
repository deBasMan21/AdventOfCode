//
//  2023-10.swift
//  AOC
//
//  Created by Bas Buijsen on 10/12/2023.
//

import Foundation

fileprivate let directions: [String: [(Double, Double)]] = ["F": [(0, 1), (1, 0)], "J": [(0, -1), (-1, 0)], "L": [(0, 1), (-1, 0)], "7": [(0, -1), (1, 0)], "|": [(-1, 0), (1, 0)], "-": [(0, 1), (0, -1)]]

fileprivate let surroundingDirections = [CGPoint(x: 0, y: -1), CGPoint(x: -1, y: 0), CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 1)]

fileprivate let validDirections: [CGPoint: [String]] = [CGPoint(x: 0, y: -1): ["7", "F", "|"], CGPoint(x: -1, y: 0): ["F", "-", "L"], CGPoint(x: 1, y: 0): ["-", "J", "7"], CGPoint(x: 0, y: 1): ["|", "J", "L"]]

func dayTen23(input: [String], partTwo: Bool) -> Int {
    let grid = input.compactMap { $0.split(separator: "").compactMap(String.init) }
    var stack = [getPreviousPoint(grid: grid), getStartingPoint(grid: grid, sPoint: getPreviousPoint(grid: grid))]
    while grid[Int(stack.last!.y)][Int(stack.last!.x)] != "S" {
        let currentPoint = stack.last!
        let currentValue = grid[Int(currentPoint.y)][Int(currentPoint.x)]
        let newValue = directions[currentValue]!
            .compactMap { CGPoint(x: currentPoint.x + $0.1, y: currentPoint.y + $0.0) }
            .first(where: { $0 != stack[stack.count - 2] })
        
        if currentValue == "S" { break }
        else if let newValue { stack.append(newValue) }
    }
    
    if partTwo {
        var emptyGrid = (0...grid.count).compactMap { _ in (0...grid.first!.count).compactMap { _ in "." } }
        stack.forEach { emptyGrid[Int($0.y)][Int($0.x)] = grid[Int($0.y)][Int($0.x)] }

        return emptyGrid.flatMap {
            var (inside, borderUp, borderDown) = (false, false, false)
            return $0.compactMap { item in
                switch item {
                case "F": borderDown = true
                case "L": borderUp = true
                case "7" where borderDown: borderDown = false
                case "J" where borderDown:
                    borderDown = false
                    inside.toggle()
                case "J" where borderUp: borderUp = false
                case "7" where borderUp:
                    borderUp = false
                    inside.toggle()
                case "|": inside.toggle()
                case "." where inside: return 1
                default: break
                }
                return 0
            }
        }.reduce(0, +)
    } else {
        return Int(floor(Double(stack.count / 2)))
    }
}

func getStartingPoint(grid: [[String]], sPoint: CGPoint) -> CGPoint {
    return surroundingDirections.compactMap {
        let point = CGPoint(x: sPoint.x + $0.x, y: sPoint.y + $0.y)
        return if validDirections[$0]!.contains(where: { $0 == grid[Int(point.y)][Int(point.x)] }) { point }
        else { nil }
    }.first!
}

func getPreviousPoint(grid: [[String]]) -> CGPoint {
    grid.enumerated().compactMap {
        return if let index = $1.firstIndex(of: "S") { CGPoint(x: Double(index), y: Double($0)) }
        else { nil }
    }.first!
}
