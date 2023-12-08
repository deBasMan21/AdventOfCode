import Foundation

func conditionOrNil<T>(_ condition: Bool, _ value: T) -> T? {
    return condition ? value : nil
}

func gcd(x: Int, y: Int) -> Int {
    var tuple = (x, y)
    while tuple.1 != 0 { tuple = (tuple.1, tuple.0 % tuple.1) }
    return tuple.0
}

func lcm(x: Int, y: Int) -> Int {
    (x / gcd(x: x, y: y)) * y
}
