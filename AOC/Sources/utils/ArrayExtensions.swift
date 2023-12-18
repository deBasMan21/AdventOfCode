//
//  ArrayExtensions.swift
//  AOC
//
//  Created by Bas Buijsen on 18/12/2023.
//

import Foundation

extension Array {
    public func adjacentPairs() -> [(Element, Element)] {
        zip(self, self.dropFirst()).map { ($0, $1) }
    }
}
