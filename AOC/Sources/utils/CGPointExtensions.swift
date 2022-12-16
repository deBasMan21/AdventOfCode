import Foundation

extension CGPoint: Hashable {
    public static func == (lhs: CGPoint, rhs: CGPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
    
    static func from(coordinate: String) -> CGPoint {
        let x = Double(String(coordinate.split(separator: ",")[0])) ?? 0.0
        let y = Double(String(coordinate.split(separator: ",")[1])) ?? 0.0
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    static func from(xyString: String) -> CGPoint {
        let parts = xyString.split(separator: ", ")
        let x = parts[0].split(separator: "=")[1]
        let y = parts[1].split(separator: "=")[1]
        return CGPoint(x: Double(x) ?? 0, y: Double(y) ?? 0)
    }
}
