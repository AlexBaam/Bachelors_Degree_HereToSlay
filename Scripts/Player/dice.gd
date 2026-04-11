extends Node2D

const FIRST_DIE: int = 1
const SECOND_DIE: int = 2
const FAILED_TO_ROLL_DICE = -9999

var die1: StaticBody2D
var die2: StaticBody2D

func _ready() -> void:
	die1 = get_die(FIRST_DIE)
	die2 = get_die(SECOND_DIE)

func get_die(die_number: int) -> StaticBody2D:
	var die: StaticBody2D
	
	match die_number:
		1:
			die = get_child(0)
		2:
			die = get_child(1)
	
	return die

func roll_dice() -> int:
	if die1.can_roll() && die2.can_roll():
		var first_die_result: int = await die1.roll_die()
		var second_die_result: int = await die2.roll_die()
		
		var die_sum: int = first_die_result + second_die_result
		return die_sum
	else:
		print("Could not roll for the card, the dice are still rolling!")
		return FAILED_TO_ROLL_DICE
