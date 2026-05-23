extends Node2D

class_name ActionPoints

@onready var action_points_sprite: Sprite2D = $AcionPointsSprite
@onready var win_checker: WinCheckerClass = $"../../GameLogic/GameOver"
@onready var player: PlayerClass = $".."

const PLAYER_ZERO_POINTS_PATH: String = "res://Textures/Backgrounds/PlayerZeroPoints.png"
const PLAYER_ONE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerOnePoint.png"
const PLAYER_TWO_POINT_PATH: String = "res://Textures/Backgrounds/PlayerTwoPoint.png"
const PLAYER_THREE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerThreePoint.png"

var action_points_left: int

enum actions {RESET = 1, RESETT = 2, UPDATE = 3}

signal check_win

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

func check_action_possibility(points_to_subtract: int) -> bool:
	if action_points_left - points_to_subtract >= 0:
		return true
	
	return false

func update_player_action_points(points_to_subtract: int) -> void:
	if check_action_possibility(points_to_subtract):
		action_points_left -= points_to_subtract
		update_sprite(action_points_left)
		print("Action succesfully realised! Used " + str(points_to_subtract) + " action points!")
		emit_signal("check_win")
	else:
		print("Action failed! This action requires " 
		+ str(points_to_subtract) + " but you only have " 
		+ str(action_points_left) + " action points!")

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


func _on_check_win() -> void:
	win_checker.check_player_win(player)
