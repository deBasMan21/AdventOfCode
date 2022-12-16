import Foundation

public func dayFourteen(input: [String], isPartOne: Bool) -> Int {
    let points = input.compactMap {
        $0.split(separator: " -> ").compactMap { String($0) }.compactMap { CGPoint.from(coordinate: $0) }
    }.compactMap { $0.windows(ofCount: 2).enumerated().compactMap { getLine(a: $1[$0], b: $1[$0 + 1]) } }.reduce([], +)
    var grid = Set(points.reduce([], +))
    let maxY = grid.sorted(by: { $0.y > $1.y }).first!.y
    var currentPoint = CGPoint(x: 500, y: 0), sandCounter = 0
    
    while true {
        guard (currentPoint.y < maxY || !isPartOne) && (!grid.contains(CGPoint(x: 500, y: 0)) || isPartOne) else { break }
        guard currentPoint.y < maxY + 1 || isPartOne else {
            grid.insert(currentPoint)
            currentPoint = CGPoint(x: 500, y: 0)
            sandCounter += 1
            continue
        }
        if !grid.contains(CGPoint(x: currentPoint.x, y: currentPoint.y + 1)) {
            currentPoint = CGPoint(x: currentPoint.x, y: currentPoint.y + 1)
        } else if !grid.contains(CGPoint(x: currentPoint.x - 1, y: currentPoint.y + 1)) {
            currentPoint = CGPoint(x: currentPoint.x - 1, y: currentPoint.y + 1)
        } else if !grid.contains(CGPoint(x: currentPoint.x + 1, y: currentPoint.y + 1)) {
            currentPoint = CGPoint(x: currentPoint.x + 1, y: currentPoint.y + 1)
        } else {
            grid.insert(currentPoint)
            currentPoint = CGPoint(x: 500, y: 0)
            sandCounter += 1
        }
    }
    return sandCounter
}

fileprivate func getLine(a: CGPoint, b: CGPoint) -> [CGPoint] {
    if a.x == b.x {
        let startingPoint = a.y - b.y < 0 ? a : b
        return (0...abs(Int(a.y - b.y))).compactMap { CGPoint(x: startingPoint.x, y: startingPoint.y + Double($0)) }
    } else {
        let startingPoint = a.x - b.x < 0 ? a : b
        return (0...abs(Int(a.x - b.x))).compactMap { CGPoint(x: startingPoint.x + Double($0), y: startingPoint.y) }
    }
}
