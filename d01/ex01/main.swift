let card1 = Card.init(color: Color.Clubs, value: Value.ace)
let card2 = Card.init(color: Color.Hearts, value: Value.five)
let card3 = Card.init(color: Color.Diamonds, value: Value.eigth)

print(card1)
print(card2)
print(card3)

print(card1.isEqual(card1))
print(card1.isEqual(card2))

print(card1 == card1)
print(card1 == card2)
