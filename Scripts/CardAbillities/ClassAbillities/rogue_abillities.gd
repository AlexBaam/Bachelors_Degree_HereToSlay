extends ClassAbillities

class_name RogueClass

const STEAL_CARD_SCENE = "res://Scenes/Abillities/StealCard.tscn"
const NUMBER_OF_CARDS_TO_BE_DESTROYED: int = 1

func use(user: Node, target: Node, _battle_manager: BattleManager, _discard_pile: DiscardPileClass) -> void:
	var abillity_scene: PackedScene = preload(STEAL_CARD_SCENE)
	var steal_card: StealCardClass = abillity_scene.instantiate()
	
	add_child(steal_card)
	
	steal_card.ability_config(NUMBER_OF_CARDS_TO_BE_DESTROYED, user, target)
