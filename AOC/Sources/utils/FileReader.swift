import Foundation

public func load(file named: String) -> String? {
    let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let bundleURL = URL(fileURLWithPath: "Inputs.bundle", relativeTo: currentDirectoryURL)
    let bundle = Bundle(url: bundleURL)
    let fileUrl = bundle!.url(forResource: named, withExtension: "txt")!
    
    guard let content = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        print("content not found")
        return nil
    }
    
    return content
}

public func loadAsArray(file named: String, splitOn: String = "\n") -> [String] {
    let content = load(file: named)
    guard let content = content else {
        print("content nil")
        return []
    }
    
    let returnValue = content.split(separator: splitOn)
    return returnValue.compactMap { String($0) }
}

public func loadAsArrayOfInt(file named: String) -> [Int] {
    let content = loadAsArray(file: named)
    return content.compactMap { Int($0) }
}
