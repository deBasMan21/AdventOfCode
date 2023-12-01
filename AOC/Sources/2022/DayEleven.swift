import Foundation

public func dayEleven(input: [String], isPartOne: Bool) -> Int {
    var monkeys = input.compactMap {
        let parts = $0.split(separator: "\n")

        let operationFunction = String(parts[2].split(separator: " = ")[1])
        var operation: Operation!
        if operationFunction.contains("+") {
            operation = .add(value: Int(operationFunction.split(separator: " + ")[1])!)
        } else if operationFunction.countInstances(of: "old") == 2 {
            operation = .squared
        } else {
            operation = .multiply(value: Int(operationFunction.split(separator: " * ")[1])!)
        }

        return Monkey(
            items: parts[1].components(separatedBy: CharacterSet(charactersIn: ":,")).compactMap { Int(String($0).trimmed()) },
            operation: operation,
            testDivisable: Int(parts[3].split(separator: "by ")[1])!,
            testTrueMonkey: Int(parts[4].split(separator: "monkey ")[1])!,
            testFalseMonkey: Int(parts[5].split(separator: "monkey ")[1])!
        )
    }
    
    let modulus = monkeys.compactMap { $0.testDivisable }.reduce(1, *)
    for _ in 1...(isPartOne ? 20 : 10000) {
        monkeys.forEach { $0.executeTests(isPartOne: isPartOne, modulus: modulus, monkeys: &monkeys) }
    }
    
    return monkeys.compactMap { $0.totalItemsInspected }.sorted(by: >).prefix(2).reduce(1, *)
}

class Monkey {
    var items: [Int]
    var operation: Operation
    var testDivisable: Int, testTrueMonkey: Int, testFalseMonkey: Int, totalItemsInspected: Int = 0
    
    init(items: [Int], operation: Operation, testDivisable: Int, testTrueMonkey: Int, testFalseMonkey: Int) {
        self.items = items
        self.operation = operation
        self.testDivisable = testDivisable
        self.testTrueMonkey = testTrueMonkey
        self.testFalseMonkey = testFalseMonkey
    }
    
    func executeTests(isPartOne: Bool, modulus: Int, monkeys: inout [Monkey]) {
        for item in items {
            totalItemsInspected += 1
            var value = Int(operation.executeOperation(oldValue: item)) % modulus
            if isPartOne { value /= 3 }
            monkeys[value % testDivisable == 0 ? testTrueMonkey : testFalseMonkey].items.append(value)
        }
        items = []
    }
}

enum Operation {
    case multiply(value: Int), add(value: Int), squared
    
    func executeOperation(oldValue: Int) -> Int {
        switch self {
        case .multiply(let value): return oldValue * value
        case .add(let value): return oldValue + value
        case .squared: return oldValue * oldValue
        }
    }
}
