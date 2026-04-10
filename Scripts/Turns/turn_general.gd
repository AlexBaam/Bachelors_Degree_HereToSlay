extends Node

class_name TurnBasedGen

## Defines when a turn should end based on the number of minimum action points
const NUMBER_OF_ACTION_POINTS: int = 0

## The fixed size of a hand the player gets at the start of the game
const BASE_HAND_SIZE: int = 5

## Function that starts the opponent's turn by disabling the collider for slots, card pile and discard pile
func disable_player_interactions(card_pile_collision: CollisionShape2D, player_hand, discard_pile_collision) -> void:
	card_pile_collision.disabled = true
	discard_pile_collision.disabled = true
	
	for slot in player_hand.player_slots:
		slot.get_child(1).get_child(0).disabled = true

## Function that starts the player's turn by enabling the collider for slots, card pile and discard pile
func enable_player_interactions(card_pile_collision: CollisionShape2D, player_hand, discard_pile_collision) -> void:
	card_pile_collision.disabled = false
	discard_pile_collision.disabled = false
	
	for slot in player_hand.player_slots:
		slot.get_child(1).get_child(0).disabled = false

## Simple function created to be reused whenever I need a wait timer of an exact value.
## The measurement unti is seconds, so wait(1.0) is wait a second.
func wait(timer: Timer, time_to_wait: float) -> void:
	timer.wait_time = time_to_wait
	timer.start()
	await timer.timeout
