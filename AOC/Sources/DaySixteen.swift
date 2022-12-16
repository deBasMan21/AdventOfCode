import Foundation
import RegexBuilder

public func daySixteen(input: [String]) -> Int {
    var caves: [String: Cave] = [:]
    input.forEach {
        let item = $0.split(separator: "Valve ")[0].split(separator: " has flow rate=").compactMap { String($0) }
        let cave = String(item[0])
        let itemSplit = item[1].split(separator: "; tunnels lead to valves ")
        let itemSingleSplit = item[1].split(separator: "; tunnel leads to valve ")
        let rate = Int(String(itemSplit[0])) ?? -1
        let tunnelsList = itemSplit.count > 1 ? itemSplit[1].split(separator: ", ").compactMap { String($0) } : [String(itemSingleSplit[1]).trimmed()]
        caves[cave] = Cave(name: cave, rate: rate, tunnels: tunnelsList)
    }
    
    print(caves)
    return 1
}

struct Cave {
    let name: String, rate: Int, tunnels: [String]
}
