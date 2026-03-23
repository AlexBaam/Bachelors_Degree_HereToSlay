extends Node

class_name TurnBasedGen

const NUMBER_OF_ACTION_POINTS: int = 3
const BASE_HAND_SIZE: int = 5

func start_opponent_turn(button: Button, card_pile_collision: CollisionShape2D, player_hand, discard_pile_collision) -> void:
	button.disabled = true
	button.visible = false
	card_pile_collision.disabled = true
	discard_pile_collision.disabled = true
	
	for slot in player_hand.player_slots:
		slot.get_child(1).get_child(0).disabled = true
	
func start_player_turn(button: Button, card_pile_collision: CollisionShape2D, player_hand, discard_pile_collision) -> void:
	button.disabled = false
	button.visible = true
	card_pile_collision.disabled = false
	discard_pile_collision.disabled = false
	
	for slot in player_hand.player_slots:
		slot.get_child(1).get_child(0).disabled = false
