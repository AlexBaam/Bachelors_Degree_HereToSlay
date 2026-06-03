extends Node2D
class_name  EnemyCardPlayer

@onready var abillity_manager: AbillityManager = $"../../../Abillities"
@onready var dice: DiceClass = $Dice

func play(card: CardClass, target: Node) -> void:
	if card.card_played_this_turn != true:
		print(card, " is now being played!")
		
		var result: int = await dice.roll_dice()
		print("Roll result is: ", result)
		
		if result >= card.card_dice_roll:
			abillity_manager.enemy_play_abillity(card.card_class, target)
		else: 
			print("Failed to play the cards abillity!")
		
		card.card_played_this_turn = true
	else:
		print(card, " already played this turn!")
