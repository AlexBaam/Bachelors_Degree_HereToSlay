extends Node2D

var game_discard_pile: Array[String] = []

@onready var cards_in_discard_pile: RichTextLabel = $RichTextLabel
@onready var discard_pile_sprite: Sprite2D = $Sprite2D

# CardPileGenerals class instance
# Used for generalising redundant code
var card_pile_gen : CardPileGen = CardPileGen.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if game_discard_pile.size() == 0:
		card_pile_gen.pile_visibility(false, discard_pile_sprite, cards_in_discard_pile)

func sanitize_card_names(card_name: String) -> String:
	var sanitized_card_name: String 
	
	for char in str(card_name):
		if not char.is_valid_int():
			sanitized_card_name = sanitized_card_name + char
			
	print(sanitized_card_name)
	return sanitized_card_name

# A function to update the discard pile by adding a card
func add_to_discard_pile(card) -> void:
	if game_discard_pile.size() == 0:
		card_pile_gen.pile_visibility(true, discard_pile_sprite, cards_in_discard_pile)
	
	# Adaugam carti in discard pile (adica array, strict doar numele cartii)
	# Crestem nr de carti in discard pile
	# Eliminam cartea din memorie
	var card_name: String = sanitize_card_names(card.name)
	game_discard_pile.append(card_name)
	cards_in_discard_pile.text = str(game_discard_pile.size())
	card.queue_free()
	
# We empty the discard pile so after refilling the card pile we can delete it
func empty_discard_pile() -> void:
	game_discard_pile.clear()
	card_pile_gen.pile_visibility(false, discard_pile_sprite, cards_in_discard_pile)
