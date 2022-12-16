import Foundation

public func dayFour(input: [String], isPartOne: Bool) -> Int {
    return input.compactMap { $0.split(separator: ",") }.compactMap {
        $0.compactMap { $0.split(separator: "-").compactMap { Int(String($0)) } }
    }.compactMap {
        let firstRange = $0[0][0]...$0[0][1]
        let secondRange = $0[1][0]...$0[1][1]
        return (isPartOne ? (firstRange.contains(secondRange) || secondRange.contains(firstRange)) : (firstRange.overlaps(secondRange) || secondRange.overlaps(firstRange))) ? 1 : nil
    }.reduce(0, +)
}
