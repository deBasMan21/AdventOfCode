//
//  2023-5.swift
//  AOC
//
//  Created by Bas Buijsen on 05/12/2023.
//

import Foundation

func dayFive23(input: [String], partTwo: Bool) -> Int {
    let seeds = input.first!.split(separator: ": ").last!.split(separator: " ").compactMap { Int($0) }
    let groupedSeeds = seeds.chunks(ofCount: 2).compactMap { $0.first! ... $0.first! + $0.last! }
    
    let stages = input.suffix(from: 1).compactMap { $0.split(separator: "\n").suffix(from: 1).compactMap { $0.split(separator: " ").compactMap { Int($0) } } }
    
    let items = stages.enumerated().compactMap { index, item in
            GenericMap(
                ranges: item.reduce(into: [SoilRange](), { acc, value in
                    acc.append(SoilRange(sourceRange: value.second! ... (value.second! + value.last!), difference: value.first! - value.second!))
                }),
                orderIndex: index
            )
        }.sorted(by: { $0.orderIndex < $1.orderIndex })
    return if partTwo {
        groupedSeeds.flatMap {
            items.reduce(into: Array<ClosedRange<Int>>(arrayLiteral: $0), { acc, value in
                acc = Array(value.getNewPositions(positionRange: acc))
            })
        }.compactMap { $0.lowerBound }.min() ?? 0
    } else {
        seeds.compactMap {
            items.reduce(into: $0, { acc, value in
                acc = value.getNewPosition(position: acc)
            })
        }.min() ?? 0
    }
}

struct GenericMap {
    let ranges: [SoilRange]
    let orderIndex: Int
    
    func getNewPosition(position: Int) -> Int {
        position + (ranges.first(where: { $0.sourceRange.contains(position) })?.difference ?? 0)
    }
    
    func getNewPositions(positionRange: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
        var finishedRanges: Set<ClosedRange<Int>> = Set()
        var currentRanges = positionRange
        while !currentRanges.isEmpty {
            var editedItem = false
            let range = currentRanges.removeFirst()
            ranges.forEach { staticRange in
                if let splitRanges = range.splitRanges(range: staticRange.sourceRange, addingAmount: staticRange.difference) {
                    finishedRanges.insert(splitRanges.0)
                    currentRanges.append(contentsOf: splitRanges.1.filter { ($0.upperBound - $0.lowerBound) > 0 })
                    editedItem = true
                }
            }
            
            if !editedItem { finishedRanges.insert(range) }
        }
        return Array(finishedRanges)
    }
}

struct SoilRange {
    let sourceRange: ClosedRange<Int>
    let difference: Int
}

extension ClosedRange<Int> {
    func addAmount(_ amount: Int) -> ClosedRange<Int> {
        lowerBound + amount ... upperBound + amount
    }
    
    func splitRanges(range: ClosedRange<Int>, addingAmount: Int) -> (ClosedRange<Int>, [ClosedRange<Int>])? {
        let lowerBoundMax = Swift.max(self.lowerBound, range.lowerBound)
        let upperBoundMin = Swift.min(self.upperBound, range.upperBound)
        
        guard (lowerBoundMax < self.upperBound && lowerBoundMax < range.upperBound) 
                && (upperBoundMin > self.lowerBound && upperBoundMin > range.lowerBound) else { return nil }
        return (
            (lowerBoundMax...upperBoundMin).addAmount(addingAmount),
            [self.lowerBound ... lowerBoundMax, upperBoundMin ... self.upperBound]
        )
    }
}
