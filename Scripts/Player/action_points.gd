extends Node2D

class_name ActionPoints

@onready var action_points_sprite: Sprite2D = $AcionPointsSprite

const PLAYER_ZERO_POINTS_PATH: String = "res://Textures/Backgrounds/PlayerZeroPoints.png"
const PLAYER_ONE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerOnePoint.png"
const PLAYER_TWO_POINT_PATH: String = "res://Textures/Backgrounds/PlayerTwoPoint.png"
const PLAYER_THREE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerThreePoint.png"

var action_points_left: int

enum actions {RESET = 1, RESETT = 2, UPDATE = 3}

func _ready() -> void:
	action_points_left = 3

func do(action: Array) -> void:
	match action[0]:
		actions.RESET:
			reset_player_turn_points_without_texture_update()
		actions.RESETT:
			reset_player_turn_points_with_texture_update()
		actions.UPDATE:
			var pts: int = int(action[1])
			update_player_action_points(pts)

func get_action_points_left() -> int:
	return action_points_left

func update_player_action_points(points_to_subtract: int) -> void:
	action_points_left -= points_to_subtract
	update_sprite(action_points_left)

func reset_player_turn_points_without_texture_update() -> void:
	action_points_left = 3

func reset_player_turn_points_with_texture_update() -> void:
	action_points_left = 3
	update_sprite(action_points_left)

func update_sprite(points_left: int) -> void:
	if points_left == 3:
		action_points_sprite.texture = load(PLAYER_THREE_POINT_PATH)
	elif points_left == 2:
		action_points_sprite.texture = load(PLAYER_TWO_POINT_PATH)
	elif points_left == 1: 
		action_points_sprite.texture = load(PLAYER_ONE_POINT_PATH)
	elif points_left == 0:
		action_points_sprite.texture = load(PLAYER_ZERO_POINTS_PATH)
