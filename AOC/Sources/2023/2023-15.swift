//
//  2023-15.swift
//  AOC
//
//  Created by Bas Buijsen on 15/12/2023.
//

import Foundation

func dayFifteen23(input: [String], partTwo: Bool) -> Int {
    let inputItems = input.compactMap { $0.replacingOccurrences(of: "\n", with: "") }
    if partTwo {
        let lenses: [any LensOperation] = inputItems.compactMap {
            return if $0.contains("-") { RemoveLens(key: String($0.split(separator: "-").first!)) }
            else { Lens(key: String($0.split(separator: "=").first!), focalLength: Int($0.split(separator: "=").last!) ?? 0) }
        }
        
        return lenses.reduce(into: [Int: [Lens]](), { acc, value in
            let hash = getSpecialHashFromString(value: value.key)
            if let value = value as? Lens {
                var list = (acc[hash] ?? [])
                if let existingIndex = list.firstIndex(where: { $0.key == value.key }) {
                    list.replaceSubrange(existingIndex...existingIndex, with: [value])
                } else { list.append(value) }
                acc[hash] = list
            } else {
                acc[hash]?.removeAll(where: { $0.key == value.key })
            }
        }).flatMap { key, value in value.enumerated().compactMap { (key + 1) * ($0.offset + 1) * $0.element.focalLength } }.reduce(0, +)
    } else {
        return inputItems.compactMap { getSpecialHashFromString(value: $0) }.reduce(0, +)
    }
}

func getSpecialHashFromString(value: String) -> Int {
    return value.reduce(into: 0, { acc, value in
        acc += Int(value.asciiValue ?? 0)
        acc *= 17
        acc %= 256
    })
}

protocol LensOperation {
    var key: String { get }
}

struct Lens: LensOperation {
    let key: String
    let focalLength: Int
}

struct RemoveLens: LensOperation {
    let key: String
}
