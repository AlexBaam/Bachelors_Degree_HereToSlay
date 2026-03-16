extends Node2D

const CARD_WIDTH = 75 # Width between the cards
const HARDCODED_Y_POSITION = 950 # Position on the Y axis of the cards
const DEFAULT_CARD_MOVE_SPEED = 0.1 # Cards default speed around the deck

var player_hand : Array = []
var center_screen_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

func add_card_to_hand(card, speed) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
		
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.in_hand_position, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_positions(speed) -> void:
	for i in range(player_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position : Vector2 = Vector2(calculate_card_position(i),HARDCODED_Y_POSITION)
		var card = player_hand[i]
		card.in_hand_position = new_position
		animate_card_to_position(card, new_position, speed)
		
func calculate_card_position(index: int):
	var x_offset = (player_hand.size() - 1) * CARD_WIDTH
	var x_position = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return x_position

func animate_card_to_position(card, new_position, speed):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card_to_remove):
	if card_to_remove in player_hand:
		player_hand.erase(card_to_remove)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
