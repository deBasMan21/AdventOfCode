//
//  Point.swift
//  AOC
//
//  Created by Bas Buijsen on 16/12/2023.
//

import Foundation

struct Point: Hashable {
    let x, y: Int
    
    static let zero = Point(x: 0, y: 0)
}
