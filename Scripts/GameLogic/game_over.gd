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
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	self.hide_game_over_screen()
	print("The game over scene is ready to be used!")

func game_over(winner: Node, reason: String) -> void:
	self.prepare_winner_text(winner, reason)
	self.show_game_over_screen()
	print("Game ended!")
	
	get_tree().paused = true

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
	
	var number_of_different_classes_in_party: int = enemy.get_diverse_party_size()
	var number_of_monsters_slayed: int = enemy.get_slayed_monsters_number()
	
	if number_of_different_classes_in_party == self.REQ_CLASSES_TO_WIN:
		print(str(enemy) + " won with enough classes!")
		self.game_over(enemy, " assembled a full party of six classes ")
	
	elif number_of_monsters_slayed == self.REQ_MONSTERS_TO_WIN:
		print(str(enemy) + " won with enough monsters ")
		self.game_over(enemy, "slayed three monsters!")
	
	else:
		print(str(enemy) + " did not win yet!")

func check_player_win(player: PlayerClass) -> void:
	print("I will check if the player wins!")
	
	var number_of_different_classes_in_party: int = player.get_diverse_party_size()
	var number_of_monsters_slayed: int = player.get_slayed_monsters_number()
	
	if number_of_different_classes_in_party == REQ_CLASSES_TO_WIN:
		print("Player won with enough classes!")
		self.game_over(player, " assembled a full party of six classes ")
	
	elif number_of_monsters_slayed == REQ_MONSTERS_TO_WIN:
		print("Player won with enough monsters!")
		self.game_over(player, " slayed three monsters ")
	
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

func prepare_winner_text(winner: Node, reason: String) -> void:
	if winner is PlayerClass:
		win_text.text = "You've" + reason + "so you've won! \nCongratulations!"
	elif winner is EnemyClass:
		win_text.text = str(winner.name) + reason + "has won!"

func _on_replay_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
