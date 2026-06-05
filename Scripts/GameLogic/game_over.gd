extends Node2D

class_name WinCheckerClass

const REQ_CLASSES_TO_WIN: int = 6
const REQ_MONSTERS_TO_WIN: int = 3

const X_SCREEN_CENTER: float = 960.0
const Y_SCREEN_CENTER: float = 540.0

@onready var replay_button: Button = $ReplayButton
@onready var exit_button: Button = $ExitButton
@onready var win_text: RichTextLabel = $WinText

func _ready() -> void:
	self.hide_game_over_screen()
	print("The game over scene is ready to be used!")

func game_over(winner: Node) -> void:
	self.prepare_winner_text(winner)
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

func check_enemy_win(enemy: EnemyClass) -> void:
	print("I will check if the " + str(enemy) + " wins!")
	var win_this_turn: bool = false
	
	var number_of_different_classes_in_party: int = enemy.get_diverse_party_size()
	
	if number_of_different_classes_in_party == self.REQ_CLASSES_TO_WIN:
		print(str(enemy) + " won with enough classes!")
		win_this_turn = true
	
	var number_of_monsters_slayed: int = enemy.get_slayed_monsters_number()
	
	if number_of_monsters_slayed == self.REQ_MONSTERS_TO_WIN:
		print(str(enemy) + " won with enough monsters!")
		win_this_turn = true
	
	if win_this_turn:
		self.game_over(enemy)
	else:
		print(str(enemy) + " did not win yet!")

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
		self.game_over(player)
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

func prepare_winner_text(winner: Node) -> void:
	if winner is PlayerClass:
		win_text.text = "You've won! Congratulations!"
	elif winner is EnemyClass:
		win_text.text = str(winner.name) + " has won!"

func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
