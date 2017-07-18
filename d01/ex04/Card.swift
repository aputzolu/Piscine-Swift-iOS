import Foundation

class Card: NSObject {
    var color: Color
    var value: Value
    
    init(color: Color, value: Value) {
        self.color = color
        self.value = value
    }
    
    override var description: String {
        return ("\(value) of \(color)")
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? Card {
            return (obj.color == self.color && obj.value == self.value)
        }
        return false
    }
}