extends Node2D
class_name  EnemyCardPlayer

@onready var dice: DiceClass = $Dice

signal request_ability_use(card_class: String, target: Node)

func play(card: CardClass, target: Node) -> void:
	if card.card_played_this_turn != true:
		print(card, " is now being played!")
		
		var result: int = await dice.roll_dice()
		print("Roll result is: ", result)
		
		if result >= card.card_dice_roll:
			request_ability_use.emit(card.card_class, target)
		else: 
			print("Failed to play the cards abillity!")
		
		card.card_played_this_turn = true
	else:
		print(card, " already played this turn!")
