extends ClassAbillities

class_name FighterClass

const DESTROY_CARD_SCENE = "res://Scenes/Abillities/DestroyCard.tscn"

const NUMBER_OF_CARDS_TO_BE_DESTROYED: int = 2

func use() -> void:
	var abillity_scene: PackedScene = preload(DESTROY_CARD_SCENE)
	var destroy_card: DestroyCard = abillity_scene.instantiate()
	
	add_child(destroy_card)
	
	destroy_card.destroy_multiple_cards(NUMBER_OF_CARDS_TO_BE_DESTROYED)
	
