import Foundation

class Deck: NSObject {
    static let allSpades: [Card] = Value.allValues.map({Card(color: Color.Spades, value: $0)})
    static let allDiamonds: [Card] = Value.allValues.map({Card(color: Color.Diamonds, value: $0)})
    static let allHearts: [Card] = Value.allValues.map({Card(color: Color.Hearts, value: $0)})
    static let allClubs: [Card] = Value.allValues.map({Card(color: Color.Clubs, value: $0)})
    static let allCards: [Card] = allSpades + allDiamonds + allHearts + allClubs
}

extension Array {
    func shuffled() -> [Element] {
        var elements = self
        for index in self.indices {
            let randomIndex = Int(arc4random_uniform(UInt32(elements.count)))
            if (index != randomIndex) {
                swap(&elements[index], &elements[randomIndex])
            }
        }
        return elements
    }
}