extends Node2D

class_name WinCheckerClass

const REQ_CLASSES_TO_WIN: int = 6
const REQ_MONSTERS_TO_WIN: int = 3

@onready var replay_button: Button = $ReplayButton
@onready var exit_button: Button = $ExitButton
@onready var win_text: RichTextLabel = $WinText

func _ready() -> void:
	self.hide_game_over_screen()
	print("The game over scene is ready to be used!")

func game_over() -> void:
	self.show_game_over_screen()
	print("Game ended!")

func hide_game_over_screen() -> void: 
	win_text.visible = false
	
	self.disable_replay_button()
	self.disable_exit_button()

func show_game_over_screen() -> void:
	win_text.visible = true
	
	self.enable_replay_button()
	self.enable_exit_button()

func check_player_win(player: PlayerClass) -> void:
	print("I will check if the player wins!")
	var win_this_turn: bool = false
	
	var number_of_different_classes_in_party: int = player.get_diverse_party_size()
	
	if number_of_different_classes_in_party == REQ_CLASSES_TO_WIN:
		print("Player won with enough classes!")
		win_this_turn = true
	
	var number_of_monsters_slayed: int = player.get_slayed_monsters_number()
	
	if number_of_monsters_slayed == REQ_MONSTERS_TO_WIN:
		print("Player won with enough monsters!")
		win_this_turn = true
	
	if win_this_turn:
		self.game_over()
	else:
		print("Player did not win yet!")

func enable_exit_button() -> void:
	exit_button.visible = true
	exit_button.disabled = false

func enable_replay_button() -> void:
	replay_button.visible = true
	replay_button.disabled = false

func disable_exit_button() -> void:
	exit_button.visible = false
	exit_button.disabled = true

func disable_replay_button() -> void:
	replay_button.visible = false
	replay_button.disabled = true
