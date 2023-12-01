import Foundation

public func dayEight(input: [String], isPartOne: Bool) -> Int {
    let twoDimArray = input.compactMap { $0.compactMap { Int(String($0)) } }
    if isPartOne {
        return twoDimArray.enumerated().compactMap { yIndex, y in
            y.enumerated().compactMap { xIndex, x in
                let vertical = twoDimArray.getVertical(index: xIndex)
                let horizontal = twoDimArray.getHorizontal(index: yIndex)
                let left = horizontal[..<xIndex].filter({ $0 >= x }).count == 0, right = horizontal[(xIndex + 1)...].filter({ $0 >= x }).count == 0
                let top = vertical[..<yIndex].filter({ $0 >= x }).count == 0, bottom = vertical[(yIndex + 1)...].filter({ $0 >= x }).count == 0
                return (right || left || top || bottom) ? 1 : 0
            }.reduce(0, +)
        }.reduce(0, +)
    } else {
        return twoDimArray.enumerated().compactMap { yIndex, y in
            y.enumerated().compactMap { xIndex, x in
                doCalcs(xIndex: xIndex, yIndex: yIndex, x: x, y: y, twoDimArray: twoDimArray)
            }.sorted(by: >).first
        }.sorted(by: >).first!
    }
}

func doCalcs(xIndex: Int, yIndex: Int, x: Int, y: [Int], twoDimArray: [[Int]]) -> Int {
    let vertical = twoDimArray.getVertical(index: xIndex)
    let horizontal = twoDimArray.getHorizontal(index: yIndex)
    let left = Array(horizontal[..<xIndex]), right = Array(horizontal[(xIndex + 1)...])
    let top = Array(vertical[..<yIndex]), bottom = Array(vertical[(yIndex + 1)...])
    return [left, right, top, bottom].enumerated().compactMap { index, side in
        for (index, item) in (index % 2 == 0 ? side.reversed() : side).enumerated() {
            if item >= x { return index + 1 }
        }
        return side.count
    }.reduce(1, *)
}
