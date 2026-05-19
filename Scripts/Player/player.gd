extends Node

class_name PlayerClass

const ACTION_POINTS: String = "action_points"
const PLAYER_HAND: String =  "player_hand"
const CARD_PLAY_BUTTON: String = "play_button"
const PLAYER_CARD_SLOTS: String = "player_card_slots"
const DISCARD_HAND_BUTTON: String = "discard_hand"

var action_points: ActionPoints 
var player_hand: PlayerHand
var card_play: Node2D
var player_slots: Node2D
var discard_hand: DiscardHandClass

var cards_in_slots: Array = []

func _ready() -> void:
	define_player_components()

func define_player_components() -> void:
	var player_components: Array = get_children()
	
	print("The list of player components is: ", player_components)
	
	player_slots = player_components[0]
	player_hand = player_components[1]
	action_points = player_components[2]
	card_play = player_components[3]
	discard_hand = player_components[4]

func update_player_cards_in_party(card_played: CardClass) -> void:
	cards_in_slots.append(card_played)
	print(cards_in_slots)

func get_action_points_left() -> int:
	return action_points.get_action_points_left()

func call_child(child_name: String, action: Array) -> void:
	var child: Node2D = get_child_via_name(child_name)
	child.do(action)

func get_child_via_name(child_name: String) -> Node2D:
	if child_name == ACTION_POINTS:
		return action_points
	elif child_name == PLAYER_HAND:
		return player_hand
	elif child_name == CARD_PLAY_BUTTON:
		return card_play
	elif child_name == PLAYER_CARD_SLOTS:
		return player_slots
	elif child_name == DISCARD_HAND_BUTTON:
		return discard_hand
	
	return null

func reset_played_cards_status() -> void: 
	for card: CardClass in cards_in_slots:
		card.card_played_this_turn = false
