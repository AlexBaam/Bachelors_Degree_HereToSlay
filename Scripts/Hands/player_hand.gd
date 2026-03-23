extends Node2D

const DEFAULT_CARD_MOVE_SPEED: float = 0.1 # Cards default speed around the deck

## This variable is the width we set between the cards in hand. 
## This is used in the following function: "calculate_card_position" where it is used as multiplier for the x_offset and x_position
@export var card_width = 85

## Position on the Y axis of the cards
@export var y_card_position = 1000

var player_hand : Array = []
var player_slots : Array = []
var center_screen_x : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot01")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot02")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot03")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot04")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot05")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot06")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot07")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot08")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot09")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot10")
	player_slots.append($"../../CardSlots/PlayerCardSlots/Slot11")
	
func add_card_to_hand(card, speed) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
		
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.in_hand_position, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_positions(speed) -> void:
	for i in range(player_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position : Vector2 = Vector2(calculate_card_position(i),y_card_position)
		var card = player_hand[i]
		card.in_hand_position = new_position
		animate_card_to_position(card, new_position, speed)
		
func calculate_card_position(index: int):
	var x_offset = (player_hand.size() - 1) * card_width
	var x_position = center_screen_x + index * card_width - x_offset / 2
	return x_position

func animate_card_to_position(card, new_position, speed):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card_to_remove):
	if card_to_remove in player_hand:
		player_hand.erase(card_to_remove)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
