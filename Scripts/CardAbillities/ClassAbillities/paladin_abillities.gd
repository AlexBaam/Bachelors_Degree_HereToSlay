extends ClassAbillities
class_name PaladinClass

const NUMBER_OF_CARDS_TO_RECRUIT: int = 1
const RECRUIT_CARD_SCENE = "res://Scenes/Abillities/RecruitCard.tscn"

func use(user: Node, target: Node, battle_manager: BattleManager, discard_pile: DiscardPileClass) -> void:
	var abillity_scene: PackedScene = preload(RECRUIT_CARD_SCENE)
	var recruit_card: RecruitCardClass = abillity_scene.instantiate()
	
	add_child(recruit_card)
	
	recruit_card.battle_manager = battle_manager
	recruit_card.discard_pile = discard_pile
	recruit_card.ability_config(NUMBER_OF_CARDS_TO_RECRUIT, user, target)
