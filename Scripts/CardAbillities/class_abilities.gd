extends Node

class_name ClassAbillities

func use(user: Node, target: Node, battle_man: BattleManager, discard_pile: DiscardPileClass) -> void:
	print("The user: " + str(user.name) + " the target: " +  str(target.name)  
	+ " battle_manager: " + str(battle_man.name) + " discard_pile: " + str(discard_pile.name))
