import Foundation
import Algorithms

public func dayTen(input: [String]) -> Int {
    let commands = input.compactMap {
        let parts = $0.split(separator: " ")
        return (String(parts[0]), parts.count == 2 ? Int(String(parts[1])) : nil)
    }
    var x = 1, i = 0
    var savedValues: [Int] = [], display: [[String]] = (0..<6).compactMap { _ in [] }
    
    for command in commands {
        increaseAndCheckScore()
        if let increaseValue = command.1 {
            increaseAndCheckScore()
            x += increaseValue
        }
    }
    
    func increaseAndCheckScore() {
        i += 1
        if (i - 20) % 40 == 0 { savedValues.append(x * i) }
        let jIndex = Int((i - 1) / 40)
        let range = (i - (jIndex * 40) - 2)...(i - (jIndex * 40))
        display[jIndex].append(range.contains(x) ? "#" : ".")
    }
    
    display.forEach { print($0.joined()) }
    return savedValues.reduce(0, +)
}
