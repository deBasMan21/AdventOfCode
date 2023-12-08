//
//  2023-8.swift
//  AOC
//
//  Created by Bas Buijsen on 08/12/2023.
//

import Foundation

fileprivate var nodes: [String: Node] = [:]
fileprivate var directions: [Substring] = []

func dayEight23(input: [String], partTwo: Bool) -> Int {
    directions = input.first!.split(separator: "")
    nodes = input.suffix(from: 1).compactMap {
        let split = $0.split(separator: " = ")
        let relationsSplit = split.second!.split(separator: ", ")
        return Node(
            name: String(split.first!),
            leftString: String(relationsSplit.first!).replacingOccurrences(of: "(", with: ""),
            rightString: String(relationsSplit.last!).replacingOccurrences(of: ")", with: "")
        )
    }.reduce(into: [String: Node]()) { $0[$1.name] = $1 }
    
    return if partTwo {
        nodes.filter { $0.key.last == "A" }.compactMap { $0.value }
            .compactMap { calculateLength(from: $0, isFinished: { $0.name.last == "Z" }) }.reduce(1, lcm)
    } else {
        calculateLength(from: nodes.first(where: { $0.key == "AAA" })!.value, isFinished: { $0.name == "ZZZ" })
    }
}

fileprivate func calculateLength(from: Node, isFinished: (Node) -> Bool) -> Int {
    var currentDirection = from
    for index in 0...Int.max {
        currentDirection = nodes[directions[index % directions.count] == "R" ? currentDirection.rightString : currentDirection.leftString]!
        if isFinished(currentDirection) { return index + 1 }
    }
    return 0
}

fileprivate struct Node {
    let name, leftString, rightString: String
}
