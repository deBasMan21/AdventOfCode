import Foundation

public func dayTwo(input: [String], isPartOne: Bool) -> Int {
    let games = input.compactMap {
        let values = $0.split(separator: " ")
        let rpcs: [Int] = values.compactMap { Int(($0.first!.asciiValue! - ($0 == "X" || $0 == "Y" || $0 == "Z" ? 23 : 0)) - ("A".first!.asciiValue!)) }
        return isPartOne ? getScore(inputOne: rpcs[0], inputTwo: rpcs[1]) : getNeeded(inputOne: rpcs[0], inputTwo: values[1])
    }
    return games.reduce(0, +)
    
    func getScore(inputOne: Int, inputTwo: Int) -> Int {
        var score = inputTwo + 1
        if inputOne == inputTwo {
            score += 3
        } else if (inputOne == 2 && inputTwo == 0) || (!(inputTwo == 2 && inputOne == 0) && inputOne < inputTwo) {
            score += 6
        }
        return score
    }
    
    func getNeeded(inputOne: Int, inputTwo: String.SubSequence) -> Int {
        switch inputTwo {
        case "X": return (inputOne - 1 < 0 ? 2 : inputOne - 1) % 3 + 1
        case "Z": return (inputOne + 1) % 3 + 7
        default: return inputOne + 4
        }
    }
}

public func dayTwoPartTwoShort(input: [String]) -> Int {
    return input.compactMap {
        let values = $0.split(separator: " ")
        let rpcs = values.compactMap { Int(($0.first!.asciiValue!) - ("A".first!.asciiValue!)) }
        let winValue = Int((values[1].first?.asciiValue ?? 0) - ("X".first?.asciiValue ?? 0)) * 3
        if values[1] == "X" { return (rpcs[0] - 1 < 0 ? 2 : rpcs[0] - 1) % 3 + winValue + 1 }
        else if values[1] == "Z" { return (rpcs[0] + 1) % 3 + 1 + winValue }
        else { return rpcs[0] + 1 + winValue }
    }.reduce(0, +)
}
