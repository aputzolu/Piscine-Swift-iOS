var deck = Deck(toShuffle: true)

print("Cards : \(deck.description)\n")

print("Outs : \(deck.outs)\n")

print("Discards : \(deck.discards)\n")

for _ in 0..<52 {
    deck.draw()
    print("Cards after draw and fold : \(deck.description)\n")
	print("Outs after draw and fold : \(deck.outs)\n")
	print("Discards after draw and fold: : \(deck.discards)\n")
}

for _ in 0..<52 {
    deck.fold(c: deck.outs[0])
    print("Cards after draw and fold : \(deck.description)\n")
	print("Outs after draw and fold : \(deck.outs)\n")
	print("Discards after draw and fold: : \(deck.discards)\n")
}

var deckSort = Deck(toShuffle:true)
var deckShuffled = Deck(toShuffle:false)

print(deckSort)
print(deckShuffled)

print(deckSort.draw()!)
print(deckShuffled.draw()!)

print(deckSort.draw()!)
print(deckShuffled.draw()!)
print(deckSort.draw()!)
print(deckShuffled.draw()!)
print(deckSort.draw()!)
print(deckShuffled.draw()!)

print(deckSort.outs)
print(deckShuffled.outs)

var aceSpade = Card(color:Color.Spades, value:Value.ace)

deckSort.fold(c: aceSpade)
deckShuffled.fold(c: aceSpade)

print(deckSort.discards)
print(deckShuffled.discards)