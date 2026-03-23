extends Node

class_name TurnBasedGen

const NUMBER_OF_ACTION_POINTS: int = 3
const BASE_HAND_SIZE: int = 5

func start_opponent_turn(button: Button, card_pile_collision: CollisionShape2D) -> void:
	button.disabled = true
	button.visible = false
	card_pile_collision.disabled = true

func start_player_turn(button: Button, card_pile_collision: CollisionShape2D) -> void:
	button.disabled = false
	button.visible = true
	card_pile_collision.disabled = false
