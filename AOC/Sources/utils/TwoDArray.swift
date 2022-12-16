import Foundation

extension Array<Array<Int>> {
    func getVertical(index: Int) -> [Int] {
        self.compactMap { $0[index] }
    }
    
    func getHorizontal(index: Int) -> [Int] {
        self[index]
    }
}

extension Array<Array<String>> {
    func printArray() {
        for item in self {
            print(item.joined())
        }
        print("")
    }
}
