//
//  2023-2.swift
//  AOC
//
//  Created by Bas Buijsen on 02/12/2023.
//

import Foundation

func dayTwo23(input: [String], partTwo: Bool) -> Int {
    return input.enumerated().compactMap { index, value in
        Game(
            id: index + 1,
            gameSets: value.split(separator: ": ").last!.split(separator: "; ").compactMap { game in
                GameSet(revealedCubes: game.split(separator: ", ").compactMap { ColorBlock.fromString($0) })
            }
        )
    }.compactMap { partTwo ? $0.getPower() : $0.isValid() }.reduce(0, +)
}

enum ColorBlock {
    case blue(Int)
    case red(Int)
    case green(Int)
    case unknown
    
    static func fromString(_ value: Substring) -> ColorBlock {
        let valueSplit = value.split(separator: " ")
        guard let intValue = Int(valueSplit.first!) else { return .unknown }
        
        return switch valueSplit.last! {
        case "blue": .blue(intValue)
        case "red": .red(intValue)
        case "green": .green(intValue)
        default: .unknown
        }
    }
}

struct Game {
    let id: Int
    let gameSets: [GameSet]
    
    func isValid() -> Int? {
        gameSets.allSatisfy { $0.isValid() } ? id : nil
    }
    
    func getPower() -> Int {
        gameSets.compactMap { $0.getMinAmount() }.reduce(MinAmount.empty, { $0.addMinAmount($1) }).getPower()
    }
}

struct GameSet {
    let revealedCubes: [ColorBlock]
    
    func isValid() -> Bool {
        revealedCubes.allSatisfy {
            return switch $0 {
            case .blue(let amount): amount <= 14
            case .green(let amount): amount <= 13
            case .red(let amount): amount <= 12
            case .unknown: false
            }
        }
    }
    
    func getMinAmount() -> MinAmount {
        revealedCubes.compactMap {
            return switch $0 {
            case .blue(let amount): MinAmount(red: 0, green: 0, blue: amount)
            case .green(let amount): MinAmount(red: 0, green: amount, blue: 0)
            case .red(let amount): MinAmount(red: amount, green: 0, blue: 0)
            case .unknown: nil
            }
        }.reduce(MinAmount.empty, { $0.addMinAmount($1) })
    }
}

struct MinAmount {
    static let empty = MinAmount(red: 0, green: 0, blue: 0)
    let red, green, blue: Int
    
    func addMinAmount(_ other: MinAmount) -> MinAmount {
        MinAmount(red: max(red, other.red), green: max(green, other.green), blue: max(blue, other.blue))
    }
    
    func getPower() -> Int {
        red * green * blue
    }
}
