extends Node

class_name AbilityComponent

var battle_manager: BattleManager
var discard_pile: DiscardPileClass

func ability_config(number: int, user: Node, target: Node) -> void:
	print("User: " + str(user.name) + " targeting: " + str(target.name) + " number of cards: " + str(number))
	pass
