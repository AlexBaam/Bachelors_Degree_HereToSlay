extends Node

var player_action_points_used: int
@onready var action_points: Node2D = $"../ActionPoints"

var cards_in_slots: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_action_points_used = 0

func update_player_action_points(points_to_add: int) -> void:
	player_action_points_used += points_to_add
	action_points.update_sprite(player_action_points_used)

func reset_player_turn_points_without_texture_update() -> void:
	player_action_points_used = 0

func reset_player_turn_points_with_texture_update() -> void:
	player_action_points_used = 0
	action_points.update_sprite(player_action_points_used)

func update_player_cards_in_party(card_played) -> void:
	cards_in_slots.append(card_played)
	print(cards_in_slots)
