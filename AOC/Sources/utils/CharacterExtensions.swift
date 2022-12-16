import Foundation

extension Character {
    func isLetter() -> Bool {
        let allCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return allCharacters.contains(self)
    }
}
