extends ClassAbillities

class_name RogueClass

const STEAL_CARD_SCENE = "res://Scenes/Abillities/StealCard.tscn"

const NUMBER_OF_CARDS_TO_BE_DESTROYED: int = 1

func use() -> void:
	var abillity_scene: PackedScene = preload(STEAL_CARD_SCENE)
	var steal_card: StealCardClass = abillity_scene.instantiate()
	
	add_child(steal_card)
	
	steal_card.ability_config(NUMBER_OF_CARDS_TO_BE_DESTROYED)

func enemy_use(target: Node) -> void:
	var abillity_scene: PackedScene = preload(STEAL_CARD_SCENE)
	var steal_card: StealCardClass = abillity_scene.instantiate()
	
	add_child(steal_card)
	
	steal_card.enemy_ability_config(NUMBER_OF_CARDS_TO_BE_DESTROYED, target)
