extends Node2D

@onready var action_points_sprite: Sprite2D = $AcionPointsSprite

const PLAYER_ZERO_POINTS_PATH: String = "res://Textures/Backgrounds/PlayerZeroPoints.png"
const PLAYER_ONE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerOnePoint.png"
const PLAYER_TWO_POINT_PATH: String = "res://Textures/Backgrounds/PlayerTwoPoint.png"
const PLAYER_THREE_POINT_PATH: String = "res://Textures/Backgrounds/PlayerThreePoint.png"

func update_sprite(points_used: int) -> void:
	if points_used == 0:
		action_points_sprite.texture = load(PLAYER_THREE_POINT_PATH)
	elif points_used == 1:
		action_points_sprite.texture = load(PLAYER_TWO_POINT_PATH)
	elif points_used == 2: 
		action_points_sprite.texture = load(PLAYER_ONE_POINT_PATH)
	elif points_used == 3:
		action_points_sprite.texture = load(PLAYER_ZERO_POINTS_PATH)
