extends Node

class_name TurnBasedGen

var card_pile_collider: CollisionShape2D
var discard_pile_collider: CollisionShape2D
var player_hand: PlayerHand
var class_player: PlayerClass
var discard_hand_button: DiscardHandClass

const PLAYER_HAND: String =  "player_hand"
const DISCARD_HAND_BUTTON: String = "discard_hand"

## Defines when a turn should end based on the number of minimum action points
const NUMBER_OF_ACTION_POINTS: int = 0

## The fixed size of a hand the player gets at the start of the game
const BASE_HAND_SIZE: int = 5

func set_variables(card_pile: CardPileClass, discard_pile: DiscardPileClass, player_received: PlayerClass) -> void:
	card_pile_collider = card_pile.get_child(1).get_child(0)
	discard_pile_collider = discard_pile.get_child(1).get_child(0)
	player_hand = player_received.get_child(1)
	discard_hand_button = player_received.get_child(4)
	class_player = player_received

## Function that starts the opponent's turn by disabling the collider for slots, card pile and discard pile
func disable_player_UI() -> void:
	update_card_pile_collider(true)
	update_discard_pile_collider(true)
	update_cards_collider(true)
	update_cards_in_slots_collider(true)
	update_discard_hand_button_collider(true)

## Function that starts the player's turn by enabling the collider for slots, card pile and discard pile
func enable_player_UI() -> void:
	update_card_pile_collider(false)
	update_discard_pile_collider(false)
	update_cards_collider(false)
	update_cards_in_slots_collider(false)
	update_discard_hand_button_collider(false)

func update_card_pile_collider(value: bool) -> void:
	card_pile_collider.disabled = value

func update_cards_collider(value: bool) -> void:
	for card: CardClass in player_hand.player_hand:
		var collider: CollisionShape2D = card.get_card_collider()
		
		collider.disabled = value

func update_discard_pile_collider(value: bool) -> void:
	discard_pile_collider.disabled = value

func update_cards_in_slots_collider(value: bool) -> void:
	for card: CardClass in class_player.cards_in_slots:
		var collider: CollisionShape2D = card.get_card_collider()
		
		collider.disabled = value

func update_discard_hand_button_collider(value: bool) -> void:
	var button: Button = discard_hand_button.get_child(0)
	button.disabled = value

## Simple function created to be reused whenever I need a wait timer of an exact value.
## The measurement unti is seconds, so wait(1.0) is wait a second.
func wait(timer: Timer, time_to_wait: float) -> void:
	timer.wait_time = time_to_wait
	timer.start()
	await timer.timeout
