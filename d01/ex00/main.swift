import Foundation

var tabValue : [Value] = Value.allValues
var tabColor : [Color] = Color.allColors

print("Values : ")
for elem in tabValue {
    print("\(elem) = \(elem.rawValue)")
}

print("\nColors : ")
for elem in tabColor {
    print("\(elem) = \(elem.rawValue)")
}