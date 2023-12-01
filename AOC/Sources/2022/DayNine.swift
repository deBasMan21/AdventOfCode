import Foundation

public func dayNine(input: [String], trailingAmount: Int) -> Int {
    let commands = input.compactMap {
        let parts = $0.split(separator: " ")
        return (String(parts[0]), Int(String(parts[1]))!)
    }
    
    let range = 0..<trailingAmount
    var posH = CGPoint(x: 0, y: 0), posT: [CGPoint] = range.compactMap { _ in CGPoint(x: 0, y: 0) }
    var trailingPositions: [[CGPoint]] = range.compactMap { _ in [CGPoint(x: 0, y: 0)] }
    
    for command in commands {
        for _ in 0..<command.1 {
            switch command.0 {
            case "U": posH = CGPoint(x: posH.x, y: posH.y - 1)
            case "D": posH = CGPoint(x: posH.x, y: posH.y + 1)
            case "L": posH = CGPoint(x: posH.x - 1, y: posH.y)
            default: posH = CGPoint(x: posH.x + 1, y: posH.y)
            }
            for index in range {
                let prev = index == 0 ? posH : posT[index - 1], follower = posT[index]
                let xdifference = prev.x - follower.x, absxdifference = abs(xdifference)
                let ydifference = prev.y - follower.y, absydifference = abs(ydifference)

                guard !(absxdifference <= 1 && absydifference <= 1) else { continue }
                if absxdifference * absydifference > 1 {
                    posT[index] = CGPoint(x: follower.x + (xdifference / absxdifference), y: follower.y + (ydifference / absydifference))
                } else if absxdifference > 1 {
                    posT[index] = CGPoint(x: follower.x + (xdifference / absxdifference), y: follower.y)
                } else {
                    posT[index] = CGPoint(x: follower.x, y: follower.y + (ydifference / absydifference))
                }
                trailingPositions[index] += [posT[index]]
            }
        }
    }
    
    return Set(trailingPositions[trailingAmount - 1]).count
}
