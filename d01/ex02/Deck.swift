import Foundation

class Deck: NSObject {
    static let allSpades: [Card] = Value.allValues.map({Card(color: Color.Spades, value: $0)})
    static let allDiamonds: [Card] = Value.allValues.map({Card(color: Color.Diamonds, value: $0)})
    static let allHearts: [Card] = Value.allValues.map({Card(color: Color.Hearts, value: $0)})
    static let allClubs: [Card] = Value.allValues.map({Card(color: Color.Clubs, value: $0)})
    static let allCards: [Card] = allSpades + allDiamonds + allHearts + allClubs
}