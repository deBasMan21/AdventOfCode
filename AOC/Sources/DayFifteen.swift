import Foundation

public func dayFifteen(input: [String], isPartOne: Bool) -> Int {
    let specificY = 2000000, max = 4000000
    var beacons: Set<CGPoint> = []
    let blockedSensors = input.compactMap {
        let parts = $0.split(separator: ": ")
        let sensor = CGPoint.from(xyString: String(parts[0].split(separator: "at ")[1]))
        let beacon = CGPoint.from(xyString: String(parts[1].split(separator: "at ")[1]))
        if Int(beacon.y) == specificY { beacons.insert(beacon) }
        return Line(start: sensor, end: beacon)
    }.compactMap { ($0.start, abs($0.start.x - $0.end.x) + abs($0.start.y - $0.end.y)) }

    for row in isPartOne ? 0...1 : (0...max) {
        var blockedPoints: [ClosedRange<Int>] = []
        let y = isPartOne ? specificY : row
        
        for sensor in blockedSensors {
            let minY = Int(sensor.0.y) - Int(sensor.1), maxY = Int(sensor.0.y) + Int(sensor.1)
            let minX = Int(sensor.0.x) - Int(sensor.1), maxX = Int(sensor.0.x) + Int(sensor.1)
            if minY <= y && maxY >= y && ((minX <= max && maxX >= 0) || isPartOne) {
                let width = Double(abs(abs(y - Int(sensor.0.y)) - Int(sensor.1)))
                let xRange = (Int(sensor.0.x - width)...Int(sensor.0.x + width))
                blockedPoints.append(xRange)
            }
        }
        
        let combined = combinedIntervals(intervals: blockedPoints)
        if isPartOne {
            return combined.first!.count - beacons.count
        } else if combined.count > 1 {
            return (combined[0].upperBound + 1) * max + row
        }
    }
    
    return -1
}

struct Line: Hashable {
    let start: CGPoint, end: CGPoint
    static func == (lhs: Line, rhs: Line) -> Bool { lhs.start.x == rhs.start.x }
    func hash(into hasher: inout Hasher) { hasher.combine(start.x) }
}
