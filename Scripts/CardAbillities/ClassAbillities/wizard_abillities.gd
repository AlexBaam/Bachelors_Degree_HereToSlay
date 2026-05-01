extends ClassAbillities

class_name WizardClass

const DRAW_DISCARDED_CARD_SCENE = "res://Scenes/Abillities/DrawDiscardedCard.tscn"
const DESTROY_CARD_SCENE = "res://Scenes/Abillities/DestroyCard.tscn"
const DISCARD_CARD_SCENE = "res://Scenes/Abillities/DiscardCard.tscn"
const STEAL_CARD_SCENE = "res://Scenes/Abillities/StealCard.tscn"

const NUMBER_OF_CARDS_TO_BE_DRAWN: int = 1

func use() -> void:
	var possibilities: Array[String] = [DESTROY_CARD_SCENE, 
										DESTROY_CARD_SCENE, 
										DISCARD_CARD_SCENE, 
										STEAL_CARD_SCENE]
	
	var ability_path: String = possibilities.pick_random()
	
	print("Chosen ability path: ", ability_path)
	
	var abillity_scene: PackedScene = load(ability_path)
	var wizard_ability: AbilityComponent = abillity_scene.instantiate()
	
	print("Wizard will use: ", wizard_ability)
	
	add_child(wizard_ability)
	
	wizard_ability.ability_config(NUMBER_OF_CARDS_TO_BE_DRAWN)
