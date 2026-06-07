extends ClassAbillities
class_name RangerClass

const DISCARD_CARD_SCENE = "res://Scenes/Abillities/DiscardCard.tscn"
const NUMBER_OF_CARDS_TO_BE_DESTROYED: int = 1

func use(user: Node, target: Node, battle_manager: BattleManager, discard_pile: DiscardPileClass) -> void:
	var abillity_scene: PackedScene = preload(DISCARD_CARD_SCENE)
	var discard_card: DiscardCardClass = abillity_scene.instantiate()
	
	add_child(discard_card)
	
	discard_card.battle_manager = battle_manager
	discard_card.discard_pile = discard_pile
	discard_card.ability_config(NUMBER_OF_CARDS_TO_BE_DESTROYED, user, target)
