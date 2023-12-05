//
//  CollectionExtensions.swift
//  AOC
//
//  Created by Bas Buijsen on 03/12/2023.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    var second: Element? {
        self.indices.contains(1) ? self[1] : nil
    }
}
