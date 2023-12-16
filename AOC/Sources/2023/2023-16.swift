//
//  2023-16.swift
//  AOC
//
//  Created by Bas Buijsen on 16/12/2023.
//

import Foundation

func daySixteen23(input: [String], partTwo: Bool) -> Int {
    let grid = input.compactMap { $0.split(separator: "").compactMap { String($0) } }
    if partTwo {
        var map = (0..<grid.count).flatMap { y in
            [runPoints(grid: grid, points: [HighlightedPoint(point: Point(x: -1, y: y), direction: .right)]),
             runPoints(grid: grid, points: [HighlightedPoint(point: Point(x: grid.first!.count, y: y), direction: .left)])]
        }
        map.append(contentsOf: (0..<grid.first!.count).flatMap { x in
            [runPoints(grid: grid, points: [HighlightedPoint(point: Point(x: x, y: -1), direction: .down)]),
             runPoints(grid: grid, points: [HighlightedPoint(point: Point(x: x, y: grid.count), direction: .up)])]
        })
        return map.max() ?? 0
    } else {
        return runPoints(grid: grid, points: [HighlightedPoint(point: Point(x: -1, y: 0), direction: .right)])
    }
}

func runPoints(grid: [[String]], points: Set<HighlightedPoint>) -> Int {
    var points = points
    var allPoints = points
    while !points.isEmpty {
        let point = points.removeFirst()
        let y = point.point.y + point.direction.getDirection().0
        let x = point.point.x + point.direction.getDirection().1
        guard let value = grid[safe: y]?[safe: x] else { continue }
        
        let newPoints = switch value {
        case ".": [point.movePoint(direction: point.direction)]
            
        case "-" where point.direction.isHorizontal(): [point.movePoint(direction: point.direction)]
        case "-": [HighlightedPoint(point: Point(x: x, y: y), direction: .right), HighlightedPoint(point: Point(x: x, y: y), direction: .left)]
            
        case "|" where point.direction.isHorizontal(): [HighlightedPoint(point: Point(x: x, y: y), direction: .up), HighlightedPoint(point: Point(x: x, y: y), direction: .down)]
        case "|": [point.movePoint(direction: point.direction)]
            
        case "/" where point.direction == .left: [HighlightedPoint(point: Point(x: x, y: y), direction: .down)]
        case "/" where point.direction == .up: [HighlightedPoint(point: Point(x: x, y: y), direction: .right)]
        case "/" where point.direction == .down: [HighlightedPoint(point: Point(x: x, y: y), direction: .left)]
        case "/" where point.direction == .right: [HighlightedPoint(point: Point(x: x, y: y), direction: .up)]
            
        case "\\" where point.direction == .left: [HighlightedPoint(point: Point(x: x, y: y), direction: .up)]
        case "\\" where point.direction == .down: [HighlightedPoint(point: Point(x: x, y: y), direction: .right)]
        case "\\" where point.direction == .up: [HighlightedPoint(point: Point(x: x, y: y), direction: .left)]
        case "\\" where point.direction == .right: [HighlightedPoint(point: Point(x: x, y: y), direction: .down)]
            
        default: fatalError(value)
        }
        points.formUnion(Set(newPoints.compactMap({ (allPoints.insert($0).inserted, $0) }).filter { $0.0 }.compactMap { $0.1 }))
    }
    
    return Set(allPoints.compactMap { $0.point }).count - 1
}

enum Direction {
    case up, down, left, right
    
    func getDirection() -> (Int, Int) {
        return switch self {
        case .up: (-1, 0)
        case .down: (1, 0)
        case .left: (0, -1)
        case .right: (0, 1)
        }
    }
    
    func isHorizontal() -> Bool {
        self == .left || self == .right
    }
}

struct HighlightedPoint: Hashable {
    let point: Point
    let direction: Direction
    
    func movePoint(direction: Direction) -> HighlightedPoint {
        let directionDelta = direction.getDirection()
        let newPoint = Point(x: point.x + directionDelta.1, y: point.y + directionDelta.0)
        return HighlightedPoint(point: newPoint, direction: direction)
    }
}
