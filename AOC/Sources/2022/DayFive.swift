import Foundation

public func dayFive(input: [String], isPartOne: Bool) -> String {
    var stacks: [Int: [Character]] = [:]
    for line in input[0].split(separator: "\n") {
        for (index, char) in line.enumerated() {
            if char.isLetter() {
                let letterIndex = (index - 1) / 4 + 1
                var currentStack = stacks[letterIndex] ?? []
                currentStack.append(char)
                stacks[letterIndex] = currentStack
            }
        }
    }
    
    for action in input[1].split(separator: "\n") {
        let steps = action.split(separator: " ").compactMap { Int(String($0)) }
        for index in 0..<steps[0] {
            var currentStack = stacks[steps[2]] ?? []
            var otherStack = stacks[steps[1]] ?? []
            currentStack.insert(otherStack.removeFirst(), at: isPartOne ? 0 : index)
            stacks[steps[2]] = currentStack
            stacks[steps[1]] = otherStack
        }
    }
    
    return stacks.sorted(by: { $0.key < $1.key }).compactMap { String($0.value[0]) }.joined()
}
