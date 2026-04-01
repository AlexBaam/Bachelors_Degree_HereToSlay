extends Node

var player_action_points_used: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_action_points_used = 0

func update_player_action_points(points_to_add: int) -> void:
	player_action_points_used += points_to_add
	
func reset_player_turn_points() -> void:
	player_action_points_used = 0
