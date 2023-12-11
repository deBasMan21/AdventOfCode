import Foundation

public func daySeven(input: [String], isPartOne: Bool) -> Int {
    let rootDir = Node(size: 0, name: "/")
    var currentDirectory = rootDir
    for line in input {
        let parts = line.split(separator: " ").compactMap { String($0) }
        if line.hasPrefix("$ cd") {
            currentDirectory = parts[2] == ".." ? currentDirectory.parent! : currentDirectory.getDir(name: parts[2])
        } else if !line.hasPrefix("dir ") {
            currentDirectory.mkFile(name: parts[1], size: Int(parts[0]) ?? 0)
        }
    }
    _ = rootDir.findSize()
    let requiredSize = abs(40000000 - (sizeList.sorted(by: >).first ?? 0))
    return isPartOne ? sizeList.filter { $0 < 100000 }.reduce(0, +) : sizeList.filter { $0 > requiredSize }.sorted(by: <).first ?? 0
}

var sizeList: [Int] = []

fileprivate class Node: Hashable {
    var parent: Node?
    var children: Set<Node>
    var size: Int
    var name: String
    
    init(parent: Node? = nil, size: Int, name: String) {
        self.parent = parent
        self.children = []
        self.size = size
        self.name = name
    }
    
    func findSize() -> Int {
        let sizeValue = size == 0 ? children.compactMap { $0.findSize() }.reduce(0, +) : size
        if size == 0 { sizeList.append(sizeValue) }
        return sizeValue
    }
    
    func getDir(name: String) -> Node {
        children.first(where: { $0.name == name }) ?? children.insert(Node(parent: self, size: 0, name: name)).1
    }
    
    func mkFile(name: String, size: Int) {
        children.insert(Node(parent: self, size: size, name: name))
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.name == rhs.name && lhs.size == rhs.size
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
