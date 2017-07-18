import Foundation

class Deck: NSObject {
    
    static let allSpades: [Card] = Value.allValues.map({Card(color: Color.Spades, value: $0)})
    static let allDiamonds: [Card] = Value.allValues.map({Card(color: Color.Diamonds, value: $0)})
    static let allHearts: [Card] = Value.allValues.map({Card(color: Color.Hearts, value: $0)})
    static let allClubs: [Card] = Value.allValues.map({Card(color: Color.Clubs, value: $0)})
    static let allCards: [Card] = allSpades + allDiamonds + allHearts + allClubs
    
    var cards: [Card] = allCards
    var discards: [Card] = []
    var outs: [Card] = []
    
    init(toShuffle: Bool) {
        if (toShuffle == true) {
            cards = cards.shuffled()
        }
    }
    override var description: String {
        return (cards.description)
    }
    
    func draw() -> Card? {
        if let out = cards.first {
            outs.append(out)
            cards.remove(at: 0)
            return (out)
        }
        return cards.first
    }
    
    func fold(c: Card) {
        if (outs.contains(c)) {
            discards.append(c)
            if let index = outs.index(of: c) {
                outs.remove(at: index)
            }
        }
    }
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