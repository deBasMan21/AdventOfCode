import Foundation

    public func dayThirteen(inputString: [String], isPartOne: Bool) -> Int {
        var input: [Packet] = inputString.compactMap { try? JSONDecoder().decode(Packet.self, from: $0.data(using: .utf8)!) }
        if !isPartOne {
            input.append(contentsOf: [.list([.list([.num(6)])]), .list([.list([.num(2)])])])
            input = input.sorted(by: <)
            return (input.firstIndex(of: .list([.list([.num(6)])]))! + 1) * (input.firstIndex(of: .list([.list([.num(2)])]))! + 1)
        }
        return stride(from: 0, to: input.count, by: 2).compactMap {
            if (input[$0] < input[$0 + 1]) { return ($0 / 2) + 1 } else { return nil }
        }.reduce(0, +)
    }

    public enum Packet: Comparable, Decodable {
        case num(Int), list([Packet])
        
        public init(from decoder: Decoder) throws {
            do {
                let c = try decoder.singleValueContainer()
                self = .num(try c.decode(Int.self))
            } catch {
                self = .list(try [Packet](from: decoder))
            }
        }
        
        public static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.num(let lValue), .num(let rValue)): return lValue < rValue
            case (.num(_), .list(_)): return .list([lhs]) < rhs
            case (.list(_), .num(_)): return lhs < .list([rhs])
            case (.list(let lValue), .list(let rValue)):
                for (l, r) in zip(lValue, rValue) {
                    if l < r { return true }
                    if l > r { return false }
                }
                return lValue.count < rValue.count
            }
        }
    }
