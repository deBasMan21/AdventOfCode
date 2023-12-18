//
//  2023-17.swift
//  AOC
//
//  Created by Bas Buijsen on 17/12/2023.
//

import Foundation

func daySeventeen23(input: [String], partTwo: Bool) -> Int {
    let grid = input.compactMap { $0.split(separator: "").compactMap { Int(String($0)) } }
    
    var visitedPoints: Set<DijkstraNode> = []
    let (first, second) = (
        DijkstraNode(point: Point(x: 0, y: 0), velocity: 0, direction: Point(x: 0, y: 1)),
        DijkstraNode(point: Point(x: 0, y: 0), velocity: 0, direction: Point(x: 1, y: 0))
    )
    var distance = [first: 0, second: 0]
    var queue = [(0, first), (0, second)]
    var destination = DijkstraNode(point: Point(x: 12, y: 12), velocity: 0, direction: Point(x: 0, y: 0))
    while !queue.isEmpty {
        queue.sort(by: { $0.0 < $1.0 })
        let item = queue.removeFirst()
        guard !visitedPoints.contains(item.1) else { continue }
        visitedPoints.insert(item.1)

        if item.1.point == destination.point && (!partTwo || item.1.velocity > 3)  {
            destination = item.1
            break
        }

        for (node, dist) in getNeighbours(grid: grid, node: item.1, partTwo: partTwo) {
            if visitedPoints.contains(node) { continue }
            let alt = distance[item.1]! + dist
            if let previousDist = distance[node] {
                if alt < previousDist {
                    distance[node] = alt
                    queue.append((alt, node))
                }
            } else {
                distance[node] = alt
                queue.append((alt, node))
            }
        }
    }
    
    return distance.filter { $0.key.point == Point(x: 12, y: 12) }.compactMap { $0.value }.min()!
}

func getNeighbours(grid: [[Int]], node: DijkstraNode, partTwo: Bool) -> [(DijkstraNode, Int)] {
    let x = node.point.x + node.direction.x
    let y = node.point.y + node.direction.y
    var returnList: [(DijkstraNode, Int)] = []
    
    // Get the same direction
    if node.velocity < (partTwo ? 10 : 3) && (x < grid.first!.count && x >= 0) && (y < grid.count && y >= 0) {
        returnList.append((DijkstraNode(point: Point(x: x, y: y), velocity: node.velocity + 1, direction: node.direction), grid[y][x]))
    }
    
    // Get right and left
    let directions = [(-node.direction.y, node.direction.x), (node.direction.y, -node.direction.x)]
    for (dx, dy) in directions {
        let xSub = node.point.x + dx
        let ySub = node.point.y + dy
        if (xSub < grid.first!.count && xSub >= 0) && (ySub < grid.count && ySub >= 0) && (!partTwo || node.velocity > 3) {
            returnList.append((DijkstraNode(point: Point(x: xSub, y: ySub), velocity: 1, direction: Point(x: dx, y: dy)), grid[ySub][xSub]))
        }
    }

    return returnList
}

struct DijkstraNode: Hashable {
    let point: Point
    let velocity: Int
    let direction: Point
}

