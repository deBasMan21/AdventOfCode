import Foundation

func conditionOrNil<T>(_ condition: Bool, _ value: T) -> T? {
    return condition ? value : nil
}
