//
//  2023-7.swift
//  AOC
//
//  Created by Bas Buijsen on 07/12/2023.
//

import Foundation

fileprivate var valueMap = ["2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "T": 10, "Q": 12, "K": 13, "A": 14]
func daySeven23(input: [String], partTwo: Bool) -> Int {
    valueMap["J"] = partTwo ? 1 : 11
    return input.compactMap {
        let spaceSplit = $0.split(separator: " ")
        return Hand(
            cards: spaceSplit.first!.split(separator: "").compactMap(String.init),
            bet: Int(spaceSplit.last!)!,
            partTwo: partTwo
        )
    }.sorted(by: { !$0.isBigger(other: $1) }).enumerated().compactMap { $0.element.bet * ($0.offset + 1) }.reduce(0, +)
}
 
struct Hand {
    let cards: [String]
    let bet: Int
    let handName: HandName
    
    init(cards: [String], bet: Int, partTwo: Bool) {
        self.cards = cards
        self.bet = bet
        
        var grouped = cards.reduce(into: [String: Int](), { $0[$1] = ($0[$1] ?? 0) + 1 }).sorted(by: { $0.value > $1.value })
        if grouped.count > 1, let j = grouped.first(where: { $0.key == "J" }), partTwo {
            let newValue = grouped.first(where: { $0.key != "J" })!.value + j.value
            let previous = grouped.removeFirst()
            grouped.removeAll(where: { $0.key == "J" })
            grouped.insert((previous.key, newValue), at: 0)
        }
        
        self.handName = if grouped.first!.value == 5 { .fiveOfAKind }
            else if grouped.first!.value == 4 { .fourOfaKind }
            else if grouped.first!.value == 3 && grouped.second!.value == 2 { .fullHouse }
            else if grouped.first!.value == 3 { .threeOfAKind }
            else if grouped.first!.value == 2 && grouped.second!.value == 2 { .twoPair }
            else if grouped.first!.value == 2 { .onePair }
            else { .highCard }
    }
    
    func isBigger(other: Hand) -> Bool {
        guard self.handName.rawValue == other.handName.rawValue else { return handName.rawValue > other.handName.rawValue }
        for (index, item) in cards.enumerated() {
            let otherValue = other.cards[index]
            if item == otherValue { continue }
            else { return valueMap[item]! > valueMap[otherValue]! }
        }
        
        return true
    }
    
    enum HandName: Int {
        case fiveOfAKind = 6, fourOfaKind = 5, fullHouse = 4, threeOfAKind = 3, twoPair = 2, onePair = 1, highCard = 0
    }
}
