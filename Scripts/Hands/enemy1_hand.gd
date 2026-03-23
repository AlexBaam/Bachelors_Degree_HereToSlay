extends Node2D

const DEFAULT_CARD_MOVE_SPEED: float = 0.1 # Cards default speed around the deck

## This variable is the width we set between the cards in hand. 
## This is used in the following function: "calculate_card_position" where it is used as multiplier for the x_offset and x_position
const CARD_WIDTH: float = 85.0

## Position on the Y axis of the cards
const E1_X_HAND_POSITION: float = 1800.0

## The angle at which I rotate the card for this enemy
const CARD_ROTATION: float = -1.57

var enemy_hand : Array = []
var empty_enemy_slots: Array = []
var center_screen_y : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_y = get_viewport().size.y /2
	
	# Gotta find a smarter way to do this
	# Nu merge cu un for de la 1 la 12 ce sa construiasca path ca string for some reason
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot1")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot2")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot3")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot4")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot5")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot6")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot7")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot8")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot9")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot10")
	empty_enemy_slots.append($"../../CardSlots/EnemyCardSlots/Enemy1/EnemySlot11")

func add_card_to_hand(card, speed) -> void:
	if card not in enemy_hand:
		enemy_hand.insert(0, card)
		
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.in_hand_position, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_positions(speed) -> void:
	for i in range(enemy_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position : Vector2 = Vector2(E1_X_HAND_POSITION, calculate_card_position(i))
		var card = enemy_hand[i]
		card.in_hand_position = new_position
		card.rotation = CARD_ROTATION
		animate_card_to_position(card, new_position, speed)
		
func calculate_card_position(index: int):
	var y_offset = (enemy_hand.size() - 1) * CARD_WIDTH
	var y_position = center_screen_y + index * CARD_WIDTH - y_offset / 2
	return y_position

func animate_card_to_position(card, new_position, speed):
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card_to_remove) -> void:
	if card_to_remove in enemy_hand:
		enemy_hand.erase(card_to_remove)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
