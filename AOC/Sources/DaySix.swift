import Foundation
import Algorithms

public func daySix(input: [String], amount: Int) -> Int? {
    input[0].windows(ofCount: amount).enumerated().compactMap { Set($1.split(separator: "")).count == amount ? $0 + amount : nil }.first
}
