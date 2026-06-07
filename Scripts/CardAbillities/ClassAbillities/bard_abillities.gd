extends ClassAbillities
class_name BardClass

const DRAW_DISCARDED_CARD_SCENE = "res://Scenes/Abillities/DrawDiscardedCard.tscn"
const NUMBER_OF_CARDS_TO_BE_DRAWN: int = 1

func use(user: Node, target: Node, battle_manager: BattleManager, discard_pile: DiscardPileClass) -> void:
	var abillity_scene: PackedScene = preload(DRAW_DISCARDED_CARD_SCENE)
	var draw_discarded_card: DrawDiscardedCardClass = abillity_scene.instantiate()
	
	add_child(draw_discarded_card)
	
	draw_discarded_card.battle_manager = battle_manager
	draw_discarded_card.discard_pile = discard_pile
	draw_discarded_card.ability_config(NUMBER_OF_CARDS_TO_BE_DRAWN, user, target)
