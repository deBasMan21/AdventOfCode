import Foundation

public func dayTwelve(input: [String], isPartOne: Bool) -> Int {
    var grid = input.compactMap { $0.split(separator: "").compactMap { String($0).first?.asciiValue }.compactMap { Int($0) - 96 } }
    var startPoint: CGPoint!, endPoint: CGPoint!
    for (yIndex, column) in grid.enumerated() {
        for (xIndex, value) in column.enumerated() {
            if value == -13 {
                startPoint = CGPoint(x: Double(xIndex), y: Double(yIndex))
                grid[yIndex][xIndex] = 1
            } else if value == -27 {
                endPoint = CGPoint(x: Double(xIndex), y: Double(yIndex))
                grid[yIndex][xIndex] = 26
            }
        }
    }
    
    let startingPoints = isPartOne ? [startPoint!] : grid.enumerated().compactMap { yIndex, column in column.enumerated().compactMap { xIndex, value in return value == 1 ? CGPoint(x: Double(xIndex), y: Double(yIndex)) : nil } }.flatMap { $0 }
    return startingPoints.compactMap { startPoint in
        var stack: [CustomPoint] = [CustomPoint(point: startPoint, index: 0)], seen: Set<CustomPoint> = Set()
        while stack.count > 0 {
            let point = stack.removeFirst()
            if point.point == endPoint { return point.index }
            if seen.contains(point) { continue }
            stack.append(contentsOf: getChildren(x: Int(point.point.x), y: Int(point.point.y), grid: grid, index: point.index + 1, currentPoints: seen))
            seen.insert(point)
        }
        return Int.max
    }.sorted(by: <).first ?? 0
}

fileprivate func getChildren(x: Int, y: Int, grid: [[Int]], index: Int, currentPoints: Set<CustomPoint>) -> [CustomPoint] {
    var height = grid[y][x], children: [CustomPoint] = []
    if grid.indices.contains(y + 1), grid[y + 1][x] <= height + 1 && grid[y + 1][x] > 0 {
        children.append(CustomPoint(point: CGPoint(x: Double(x), y: Double(y) + 1), index: index))
    }
    if grid.indices.contains(y - 1), grid[y - 1][x] <= height + 1 && grid[y - 1][x] > 0 {
        children.append(CustomPoint(point: CGPoint(x: Double(x), y: Double(y) - 1), index: index))
    }
    if grid[0].indices.contains(x + 1), grid[y][x + 1] <= height + 1 && grid[y][x + 1] > 0 {
        children.append(CustomPoint(point: CGPoint(x: Double(x) + 1, y: Double(y)), index: index))
    }
    if grid[0].indices.contains(x - 1), grid[y][x - 1] <= height + 1 && grid[y][x - 1] > 0 {
        children.append(CustomPoint(point: CGPoint(x: Double(x) - 1, y: Double(y)), index: index))
    }
    return children.filter { child in !currentPoints.contains(child) }
}

fileprivate class CustomPoint: Hashable, Equatable {
    var point: CGPoint, index: Int
    init(point: CGPoint, index: Int) {
        self.point = point
        self.index = index
    }
    
    static func == (lhs: CustomPoint, rhs: CustomPoint) -> Bool { lhs.point == rhs.point }
    func hash(into hasher: inout Hasher) { hasher.combine(point) }
}
