extends Node2D

class_name PlayerHand

## This variable is the width we set between the cards in hand. 
## This is used in the following function: "calculate_card_position" where it is used as multiplier for the x_offset and x_position
@export var card_width: float = 85

## Position on the Y axis of the cards
@export var y_card_position: float = 1000

var player_hand : Array[CardClass] = []
var center_screen_x : float

func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2

#METHODS THAT ARE CALLABLE BY THE PLAYER CLASS FOR EXTERNAL USE

func add_card_to_hand(card: CardClass, speed: float) -> void:
	if card not in player_hand:
		player_hand.insert(0, card)
		
		self.update_hand_positions(speed)
	else:
		self.animate_card_to_hand(card, card.in_hand_position, speed)
	
	print("Player hand: ", player_hand)

func remove_card_from_hand(card_to_remove: CardClass, speed: float) -> void:
	print("Card to remove from hand: ", card_to_remove)
	if card_to_remove in player_hand:
		player_hand.erase(card_to_remove)
		self.update_hand_positions(speed)

func update_hand_positions(speed: float) -> void:
	for i in range(player_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position : Vector2 = Vector2(self.calculate_card_position(i),y_card_position)
		var card: CardClass = player_hand[i]
		card.in_hand_position = new_position
		self.animate_card_to_hand(card, new_position, speed)

#HERE ARE THE GETTERS BECAUSE I NEED EM

func remove_every_card_from_hand() -> void: 
	player_hand.clear()

func get_hand_size() -> int:
	return self.player_hand.size()

func get_player_cards_hand() -> Array[CardClass]:
	return self.player_hand

#SOME INTERNAL FUNCTIONS THAT THE CODE WILL USE

func calculate_card_position(index: int) -> float:
	var x_offset: float = (player_hand.size() - 1) * card_width
	var x_position: float = center_screen_x + index * card_width - x_offset / 2
	return x_position

func animate_card_to_hand(card: CardClass, new_position: Vector2, speed: float) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
