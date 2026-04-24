extends Node

class_name Card

## Cards default speed around the deck
const DEFAULT_CARD_MOVE_SPEED: float = 0.1

## Used in card manager
var slot_of_the_card

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

func animate_card_to_position(card: Card, new_position: Vector2, speed: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
