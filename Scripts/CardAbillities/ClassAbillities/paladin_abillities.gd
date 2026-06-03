extends ClassAbillities

class_name PaladinClass

const NUMBER_OF_CARDS_TO_RECRUIT: int = 1

const RECRUIT_CARD_SCENE = "res://Scenes/Abillities/RecruitCard.tscn"

func use() -> void:
	var abillity_scene: PackedScene = preload(RECRUIT_CARD_SCENE)
	var recruit_card: RecruitCardClass = abillity_scene.instantiate()
	
	add_child(recruit_card)
	
	recruit_card.ability_config(NUMBER_OF_CARDS_TO_RECRUIT)

func enemy_use(target: Node) -> void:
	var abillity_scene: PackedScene = preload(RECRUIT_CARD_SCENE)
	var recruit_card: RecruitCardClass = abillity_scene.instantiate()
	
	add_child(recruit_card)
	
	recruit_card.enemy_ability_config(NUMBER_OF_CARDS_TO_RECRUIT, target)
