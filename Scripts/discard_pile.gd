extends Node2D

var game_discard_pile: Array[String] = []

@onready var cards_in_discard_pile: RichTextLabel = $RichTextLabel
@onready var discard_pile_sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if game_discard_pile.size() == 0:
		discard_pile_sprite.visible = false
		cards_in_discard_pile.visible = false

func update_discard_pile(card) -> void:
	if game_discard_pile.size() == 0:
		discard_pile_sprite.visible = true
		cards_in_discard_pile.visible = true
	
	# Adaugam carti in discard pile (adica array, strict doar numele cartii)
	# Crestem nr de carti in discard pile
	# Eliminam cartea din memorie
	var card_name: String = str(card.name)
	game_discard_pile.append(card_name)
	cards_in_discard_pile.text = str(game_discard_pile.size())
	card.queue_free()
	
	print(game_discard_pile)
	
