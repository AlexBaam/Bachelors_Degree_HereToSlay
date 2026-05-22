extends Node2D

@onready var replay_button: Button = $ReplayButton
@onready var exit_button: Button = $ExitButton
@onready var win_text: RichTextLabel = $WinText

func _ready() -> void:
	hide_game_over_screen()
	print("The scene is ready to be used!")

func game_over() -> void:
	print("Game ended!")

func hide_game_over_screen() -> void: 
	win_text.visible = false
	
	disable_replay_button()
	disable_exit_button()

func disable_exit_button() -> void:
	exit_button.visible = false
	exit_button.disabled = true

func disable_replay_button() -> void:
	replay_button.visible = false
	replay_button.disabled = true
