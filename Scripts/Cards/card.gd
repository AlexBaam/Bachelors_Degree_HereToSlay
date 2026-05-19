extends Node

class_name CardClass

## Constant that defines the collision mask of a player card
const COLLISION_MASK_PLAYER_CARD: int = 1

## Constant that defines the collision mask of an enemy card
const COLLISION_MASK_ENEMY_CARD: int = 256

## Cards default speed around the deck
const DEFAULT_CARD_MOVE_SPEED: float = 0.1

## The angle at which I rotate the card for this enemy
const VERTICAL_CARDS_ROTATION: float = 0.0

## The angle at which I rotate the card for this enemy
const HORIZONTAL_CARDS_ROTATION: float = -1.57

## Used in card manager
var slot_of_the_card: SlotClass

## Used in player hand
var in_hand_position: Vector2

## This variable defines the type of the card that it gets from cards_database
var card_type: String

## This variable defines the class of the card that it gets from cards_database. This variable is only available for "Hero" type cards, any other type of card will have "null" as their class.
var card_class: String

## This variable defines the result of the dice roll to activate the card's abillity.
var card_dice_roll: int

## Variable to define if a card has been already played this turn.
var card_played_this_turn: bool

signal hovered
signal hovered_off

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#All the cards must be a child of a card manager or this will break
	get_parent().connect_card_signals(self)

# We emit a signal when we hover over the card (this will help us animate the size increse)
func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

# We emit a signal when we hover off the card (this will help us animate the size decrease)
func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

func animate_card_to_position(card: CardClass, new_position: Vector2, speed: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)

func change_card_collision_mask(collision_mask: int) -> int:
	if collision_mask == COLLISION_MASK_ENEMY_CARD:
		#print("Old card collision mask: ", collision_mask)
		collision_mask = COLLISION_MASK_PLAYER_CARD
		#print("New card collision mask: ", collision_mask)
	elif collision_mask == COLLISION_MASK_PLAYER_CARD:
		#print("Old card collision mask: ", collision_mask)
		collision_mask = COLLISION_MASK_ENEMY_CARD
		#print("New card collision mask: ", collision_mask)
		
	return collision_mask

func update_card_rotation(collision_mask: int, card_rotation: float) -> float:
	if collision_mask == COLLISION_MASK_ENEMY_CARD:
		#print("Old card rotation mask: ", card_rotation)
		card_rotation = VERTICAL_CARDS_ROTATION
		#print("New card rotation mask: ", card_rotation)
	elif collision_mask == COLLISION_MASK_PLAYER_CARD:
		#print("Old card rotation mask: ", card_rotation)
		card_rotation = HORIZONTAL_CARDS_ROTATION
		#print("New card rotation mask: ", card_rotation)
		
	return card_rotation

## A function used to change a cards behavior and aspect from an enemy card to a player card
func convert_card_functionality(card: CardClass) -> void:
	var collision_mask: int = card.get_child(2).collision_mask
	var card_rotation: float = card.rotation
	
	# Changing the collision mask is essential for the card to be interactable to the player
	# collision mask = 1 is for player cards, and collision mask = 256 is for enemy cards (2 at the 8th power, meaning the 9th value in the collision mask table as it starts from 1 and not 0)
	card.get_child(2).collision_mask = self.change_card_collision_mask(collision_mask)
	
	card.rotation = update_card_rotation(collision_mask, card_rotation)
	
	card.get_node("CardFlipAnimation").play("card_flip")

func get_card_collider() -> CollisionShape2D:
	var area2D: Area2D = self.get_child(2)
	var collision_shape2D: CollisionShape2D = area2D.get_child(0)
	
	return collision_shape2D
