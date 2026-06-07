extends ClassAbillities
class_name WizardClass

const DRAW_DISCARDED_CARD_SCENE = "res://Scenes/Abillities/DrawDiscardedCard.tscn"
const DESTROY_CARD_SCENE = "res://Scenes/Abillities/DestroyCard.tscn"
const DISCARD_CARD_SCENE = "res://Scenes/Abillities/DiscardCard.tscn"
const STEAL_CARD_SCENE = "res://Scenes/Abillities/StealCard.tscn"
const RECRUIT_CARD_SCENE = "res://Scenes/Abillities/RecruitCard.tscn"

const NUMBER_OF_CARDS_TO_BE_DRAWN: int = 1

func use(user: Node, target: Node, battle_manager: BattleManager, discard_pile: DiscardPileClass) -> void:
	var possibilities: Array[String] = [
		DESTROY_CARD_SCENE, 
		DISCARD_CARD_SCENE, 
		STEAL_CARD_SCENE,
		RECRUIT_CARD_SCENE
	]
	
	var ability_path: String = possibilities.pick_random()
	var abillity_scene: PackedScene = load(ability_path)
	var wizard_ability: AbilityComponent = abillity_scene.instantiate()
	
	add_child(wizard_ability)
	
	# Securely pass the references!
	wizard_ability.battle_manager = battle_manager
	wizard_ability.discard_pile = discard_pile
	wizard_ability.ability_config(NUMBER_OF_CARDS_TO_BE_DRAWN, user, target)
