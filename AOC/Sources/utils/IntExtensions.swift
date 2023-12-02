//
//  IntExtensions.swift
//  AOC
//
//  Created by Bas Buijsen on 02/12/2023.
//

import Foundation

extension Int {
    init?(_ value: Substring) {
        self.init(String(value))
    }
}
