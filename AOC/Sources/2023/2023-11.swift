//
//  2023-11.swift
//  AOC
//
//  Created by Bas Buijsen on 11/12/2023.
//

import Foundation

func dayEleven23(input: [String], partTwo: Bool) -> Double {
    let grid = input.compactMap { $0.split(separator: "") }
    let points = grid.enumerated().flatMap { index, value in
        value.enumerated().filter { $1 == "#" }.compactMap { CGPoint(x: Double($0.offset), y: Double(index)) }
    }
    
    var routes: [Route] = []
    var pointsStack = points
    while !pointsStack.isEmpty {
        let point = pointsStack.removeFirst()
        routes.append(contentsOf: pointsStack.compactMap { Route(start: point, end: $0) })
    }
    
    let emptyRowIndices = grid.enumerated().filter { $0.element.allSatisfy { $0 == "." } }.compactMap { $0.offset }
    let emptyColumnIndices = grid.first!.enumerated().filter { index, element in grid.allSatisfy { $0[index] == "." } }.compactMap { $0.offset }
    
    return routes.compactMap { route in
        let amountOfCrossedRows = emptyRowIndices.filter { $0 > Int(min(route.start.y, route.end.y)) && $0 < Int(max(route.start.y, route.end.y)) }.count
        let amountOfCrossedColumns = emptyColumnIndices.filter { $0 > Int(min(route.start.x, route.end.x)) && $0 < Int(max(route.start.x, route.end.x)) }.count
        return route.getDistance() + Double((amountOfCrossedRows + amountOfCrossedColumns) * (partTwo ? 999999 : 1))
    }.reduce(0, +)
}

struct Route {
    let start, end: CGPoint
    
    func getDistance() -> Double {
        abs(start.x - end.x) + abs(start.y - end.y)
    }
}
