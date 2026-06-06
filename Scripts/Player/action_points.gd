extends Node2D

class_name ActionPoints

@onready var action_points_sprite: Sprite2D = $AcionPointsSprite

const PLAYER_ZERO_POINTS_PATH: String = "res://Textures/Backgrounds/PlayerZeroPoints.png"
const PLAYER_ONE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerOnePoint.png"
const PLAYER_TWO_POINT_PATH: String = "res://Textures/Backgrounds/PlayerTwoPoint.png"
const PLAYER_THREE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerThreePoint.png"

var action_points_left: int

signal check_win

func _ready() -> void:
	action_points_left = 3

#METHODS CALLABLE FROM PLAYER 

func update_player_action_points(points_to_subtract: int) -> void:
	if self.check_action_possibility(points_to_subtract):
		action_points_left -= points_to_subtract
		self.update_sprite(action_points_left)
		print("Action succesfully realised! Used " + str(points_to_subtract) + " action points!")
		self.check_win.emit()
	else:
		print("Action failed! This action requires " 
		+ str(points_to_subtract) + " but you only have " 
		+ str(action_points_left) + " action points!")

func reset_player_turn_points_without_texture_update() -> void:
	action_points_left = 3

func reset_player_turn_points_with_texture_update() -> void:
	action_points_left = 3
	self.update_sprite(action_points_left)

#GETTER RAAAAAAAAAAAAAAAAAAAAAAAH

func get_action_points_left() -> int:
	return action_points_left

#INTERNAL HELPERS dsnofgkaskf

func check_action_possibility(points_to_subtract: int) -> bool:
	return action_points_left >= points_to_subtract

func update_sprite(points_left: int) -> void:
	if points_left == 3:
		action_points_sprite.texture = load(PLAYER_THREE_POINT_PATH)
	elif points_left == 2:
		action_points_sprite.texture = load(PLAYER_TWO_POINT_PATH)
	elif points_left == 1: 
		action_points_sprite.texture = load(PLAYER_ONE_POINT_PATH)
	elif points_left == 0:
		action_points_sprite.texture = load(PLAYER_ZERO_POINTS_PATH)
