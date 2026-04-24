extends Node2D

const DEFAULT_CARD_MOVE_SPEED: float = 0.1 # Cards default speed around the deck

## The Y position of both vertical enemies in the game
## Used to check enemy positioning to further position their hand on the screen
const VERTICAL_ENEMIES_Y: float = 465

## The X position of each hand for enemy 1
const E1_X_HAND_POSITION: float = 1800

## The X position of each hand for enemy 3
const E3_X_HAND_POSITION: float = 160

## This variable is the width we set between the cards in hand. 
## This is used in the following function: "calculate_card_position" where it is used as multiplier for the x_offset and x_position
const CARD_WIDTH: float = 85.0

## The angle at which I rotate the card for this enemy
const CARD_ROTATION: float = -1.57

## Position on the Y axis of the cards
var x_hand_position: float

var enemy_hand : Array = []
var empty_enemy_slots: Array = []
var center_screen_y : float

@onready var enemy: EnemyClass = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_hand_position()
	center_screen_y = get_viewport().size.y /2
	
	for child in enemy.get_child(1).get_children():
		empty_enemy_slots.append(child)

func get_parent_position() -> Vector2:
	var parent_x: float = enemy.position.x
	var parent_y: float = enemy.position.y
	
	var parent_positions: Vector2 = Vector2(parent_x, parent_y)
	
	return parent_positions

func set_hand_position() -> void:
	var parent_positions: Vector2 = get_parent_position()
	
	if parent_positions.y == VERTICAL_ENEMIES_Y:
		if parent_positions.x <= 960:
			x_hand_position = E3_X_HAND_POSITION
		else:
			x_hand_position = E1_X_HAND_POSITION
	else:
		x_hand_position = 0 # TO BE CHANGED!!!!!

func add_card_to_hand(card: Node2D, speed: float) -> void:
	if card not in enemy_hand:
		enemy_hand.insert(0, card)
		
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.in_hand_position, DEFAULT_CARD_MOVE_SPEED)
	
func update_hand_positions(speed: float) -> void:
	for i in range(enemy_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position: Vector2 = Vector2(x_hand_position, calculate_card_position(i))
		var card: Node2D = enemy_hand[i]
		card.in_hand_position = new_position
		card.rotation = CARD_ROTATION
		animate_card_to_position(card, new_position, speed)
		
func calculate_card_position(index: int) -> float:
	var y_offset: float = (enemy_hand.size() - 1) * CARD_WIDTH
	var y_position: float = center_screen_y + index * CARD_WIDTH - y_offset / 2
	return y_position

func animate_card_to_position(card: Node2D, new_position: Vector2, speed: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func remove_card_from_hand(card_to_remove: Node2D) -> void:
	if card_to_remove in enemy_hand:
		enemy_hand.erase(card_to_remove)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)
