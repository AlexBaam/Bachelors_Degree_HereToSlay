extends Node2D

const HAND_COUNT = 5
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARD_WIDTH = 100
const HARDCODED_Y_POSITION = 890

@onready var card_manager: Node2D = $"../CardManager"
var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2
	
	var card_scene = preload(CARD_SCENE_PATH)
	
	for i in range(HAND_COUNT):
		var new_card = card_scene.instantiate()
		card_manager.add_child(new_card)
		new_card.name = "Card"
		add_card_to_hand(new_card)

func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(card, card.in_hand_position)
	
func update_hand_positions():
	for i in range(player_hand.size()):
		# Setting the position of cards in the hand for adding and removing cards
		var new_position = Vector2(calculate_card_position(i),HARDCODED_Y_POSITION)
		var card = player_hand[i]
		card.in_hand_position = new_position
		animate_card_to_position(card, new_position)
		
func calculate_card_position(index: int):
	var x_offset = (player_hand.size() - 1) * CARD_WIDTH
	var x_position = center_screen_x + index * CARD_WIDTH - x_offset / 2
	return x_position

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)

func remove_card_from_hand(card_to_remove):
	if card_to_remove in player_hand:
		player_hand.erase(card_to_remove)
		update_hand_positions()
