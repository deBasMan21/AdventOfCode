//
//  2023-18.swift
//  AOC
//
//  Created by Bas Buijsen on 18/12/2023.
//

import Foundation

func dayEighteen23(input: [String], partTwo: Bool) -> Int {
    let directions: [String: Direction] = partTwo ? ["0": .right, "1": .down, "2": .left, "3": .up] : ["L": .left, "R": .right, "U": .up, "D": .down]
    let instructions = input.compactMap {
        let split = $0.split(separator: " ")
        let color = Int(String(split.last!).subrange(from: 2, to: 7), radix: 16)!
        return DigInstruction(
            direction: directions[partTwo ? String(color & 0xf) : String(split.first!)]!,
            amount: partTwo ? color >> 4 :  Int(String(split.second!))!
        )
    }
    
    let (_, points) = instructions.reduce(into: (Point.zero, [Point.zero]), {
        let direction = $1.direction.getDirection()
        let newPoint = Point(x: $0.0.x + (direction.1 * $1.amount), y: $0.0.y + (direction.0 * $1.amount))
        $0.1.append(newPoint)
        $0.0 = newPoint
    })
    
    return (points.adjacentPairs().compactMap { ($0.x * $1.y) - ($0.y * $1.x) }.reduce(0, +)) / 2 + (instructions.reduce(into: 0, { $0 += $1.amount })) / 2 + 1
}

fileprivate struct DigInstruction {
    let direction: Direction
    let amount: Int
}

extension String {
    func subrange(from: Int, to: Int) -> String {
        Array(self.compactMap { $0 }[from...to]).compactMap { String($0) }.joined()
    }
}
