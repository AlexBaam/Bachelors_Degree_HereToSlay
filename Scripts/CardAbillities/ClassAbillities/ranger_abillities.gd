extends ClassAbillities

class_name RangerClass

const DISCARD_CARD_SCENE = "res://Scenes/Abillities/DiscardCard.tscn"

const NUMBER_OF_CARDS_TO_BE_DESTROYED: int = 1

func use() -> void:
	var abillity_scene: PackedScene = preload(DISCARD_CARD_SCENE)
	var discard_card: DiscardCardClass = abillity_scene.instantiate()
	
	add_child(discard_card)
	
	discard_card.discard_multiple_cards(NUMBER_OF_CARDS_TO_BE_DESTROYED)
