extends Node2D

class_name PlayerHand

const DEFAULT_CARD_MOVE_SPEED: float = 0.1 # Cards default speed around the deck

## This variable is the width we set between the cards in hand. 
## This is used in the following function: "calculate_card_position" where it is used as multiplier for the x_offset and x_position
@export var card_width = 85

## Position on the Y axis of the cards
@export var y_card_position: float = 1000

var player_hand : Array[CardClass] = []
var player_slots : Array[SlotClass] = []
var center_screen_x : float

enum actions {ADD = 1, UPDATE = 2,  REMOVE = 3}

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	for slot in $"../PlayerCardSlots".get_children():
		player_slots.append(slot)

func do(action: Array) -> void:
	match action[0]:
		actions.ADD:
			var card: CardClass = action[1]
			var speed: float = float(action[2])
			add_card_to_hand(card, speed)
		actions.UPDATE:
			var speed: float = float(action[1])
			update_hand_positions(speed)
		actions.REMOVE:
			var card: CardClass = action[1]
			remove_card_from_hand(card)

func add_card_to_hand(card: CardClass, speed: float) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
		
		update_hand_positions(speed)
	else:
		animate_card_to_hand(card, card.in_hand_position, DEFAULT_CARD_MOVE_SPEED)
	
	print("Player hand: ", player_hand)

func update_hand_positions(speed: float) -> void:
	for i in range(player_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position : Vector2 = Vector2(calculate_card_position(i),y_card_position)
		var card: CardClass = player_hand[i]
		card.in_hand_position = new_position
		animate_card_to_hand(card, new_position, speed)

func calculate_card_position(index: int) -> float:
	var x_offset: float = (player_hand.size() - 1) * card_width
	var x_position: float = center_screen_x + index * card_width - x_offset / 2
	return x_position

func animate_card_to_hand(card: CardClass, new_position: Vector2, speed: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card_to_remove: CardClass) -> void:
	print("Card to remove from hand: ", card_to_remove)
	if card_to_remove in player_hand:
		player_hand.erase(card_to_remove)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
