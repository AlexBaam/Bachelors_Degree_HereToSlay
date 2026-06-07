extends ClassAbillities
class_name FighterClass

const DESTROY_CARD_SCENE = "res://Scenes/Abillities/DestroyCard.tscn"
const NUMBER_OF_CARDS_TO_BE_DESTROYED: int = 2

func use(user: Node, target: Node, battle_manager: BattleManager, discard_pile: DiscardPileClass) -> void:
	var abillity_scene: PackedScene = preload(DESTROY_CARD_SCENE)
	var destroy_card: DestroyCardClass = abillity_scene.instantiate()
	
	add_child(destroy_card)
	
	destroy_card.battle_manager = battle_manager
	destroy_card.discard_pile = discard_pile
	destroy_card.ability_config(NUMBER_OF_CARDS_TO_BE_DESTROYED, user, target)
