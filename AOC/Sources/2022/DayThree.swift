import Foundation
import Algorithms

public func dayThree(input: [String], isPartOne: Bool) -> Int {
    if isPartOne {
        return input.compactMap { inputItem in
            Int(inputItem[inputItem.count / 2..<inputItem.count].compactMap { conditionOrNil(inputItem[0..<inputItem.count / 2].contains($0), (($0.asciiValue ?? 0) - ($0.isUppercase ? 38 : 96))) }.first!)
        }.reduce(0, +)
    } else {
        let chunked = input.chunks(ofCount: 3).map(Array.init)
        let values = chunked.compactMap { firstItem in
            firstItem[0].compactMap { firstItem[1].contains($0) && firstItem[2].contains($0) ? String($0) : nil }.first
        }.compactMap { Int(($0.first!.asciiValue ?? 0) - ($0.first!.isUppercase ? 38 : 96)) }
        return values.reduce(0, +)
    }
}
