import Foundation

public func dayOne(amount: Int, input: [String]) -> Int {
    return input.map {
        $0.split(separator: "\n").compactMap { Int($0) }.reduce(0, +)
    }.sorted(by: >)[0...amount].reduce(0, +)
}

public func dayOneRecursive(amount: Int, input: [String]) -> Int {
    var values = input.map {
        $0.split(separator: "\n").compactMap { Int($0) }.reduce(0, +)
    }
    var highestThree: [Int] = []
    
    for _ in 0...amount {
        let highest = getHighest(values: values)
        values.remove(at: values.firstIndex(of: highest) ?? 0)
        highestThree.append(highest)
    }
    
    func getHighest(index: Int = 0, values: [Int]) -> Int {
        guard index < values.count - 1 else {
            return values[index]
        }
        let next = getHighest(index: index + 1, values: values)
        return next > values[index] ? next : values[index]
    }
    
    return highestThree.reduce(0, +)
}
