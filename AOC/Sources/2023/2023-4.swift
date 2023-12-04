//
//  2023-4.swift
//  AOC
//
//  Created by Bas Buijsen on 04/12/2023.
//

import Foundation

func dayFour23(input: [String], partTwo: Bool) -> Int {
    let cards = input.enumerated().compactMap { index, value in
        let lists = value.split(separator: ": ").last!.split(separator: " | ")
        return Card(
            id: index + 1,
            winningNumbers: Set(lists.first!.split(separator: " ").compactMap { Int(String($0)) }),
            cardNumbers: Set(lists.last!.split(separator: " ").compactMap { Int(String($0)) })
        )
    }
    
    if partTwo {
        let cardMap: [Int: [Int]] = cards.reduce(into: [:], { $0[$1.id] = $1.getCards() })
        let calculatedCards = cards.reversed().compactMap { $0.id }.reduce(into: [Int: Int](), { acc, value in
            acc[value] = cardMap[value]?.isEmpty == false ? cardMap[value]?.reduce(1, { $0 + (acc[$1] ?? 1) }) : 1
        })
        return cards.reduce(0, { $0 + (calculatedCards[$1.id] ?? 0)})
    } else {
        return (cards.compactMap { $0.getPoints() }.filter { !$0.isNaN }.reduce(0, +) as NSDecimalNumber).intValue
    }
}

struct Card {
    let id: Int
    let winningNumbers, cardNumbers: Set<Int>
    
    func getPoints() -> Decimal {
        pow(2, cardNumbers.intersection(winningNumbers).count - 1)
    }
    
    func getCards() -> [Int] {
        let amount = cardNumbers.intersection(winningNumbers).count
        guard amount > 0 else { return [] }
        return (id + 1 ... id + amount).compactMap { $0 }
    }
}
