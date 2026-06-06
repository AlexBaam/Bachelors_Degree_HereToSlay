extends Node2D

class_name CardPlayer

@onready var play_card_button: Button = $PlayCardButton
@onready var player: PlayerClass = $".."
@onready var dice: DiceClass = $"../Dice"

const ACTION_COST: int = 1
var card_to_play: CardClass

signal request_ui_lock(is_locked: bool)
signal request_ability_use(card_class: String)
signal request_card_unselect()

func _ready() -> void:
	self.hide_button()

#CALLABLE FROM THE PLAYER

func show_button() -> void:
	play_card_button.visible = true
	play_card_button.disabled = false

func hide_button() -> void:
	play_card_button.visible = false
	play_card_button.disabled = true

func attach_to_card(card: CardClass) -> void:
	play_card_button.position = Vector2(card.position.x - 23, card.position.y - 90)
	card_to_play = card
	self.show_button()

func play(card: CardClass) -> void:
	if card.card_played_this_turn != true:
		print(card, " is now being played!")
		
		request_ui_lock.emit(true)
		
		print("Card's dice roll to activate: " + str(card.card_dice_roll))
		var result: int = await dice.roll_dice()
		print("Roll result is: ", result)
		
		if result >= card.card_dice_roll:
			request_ability_use.emit(card.card_class)
		else: 
			print("Failed to play the cards abillity!")
		
		card.card_played_this_turn = true
		
		player.update_player_action_points(ACTION_COST)
		request_ui_lock.emit(false)
	else:
		print(card, " already played this turn!")

func _on_play_card_button_pressed() -> void:
	self.play(card_to_play)
	request_card_unselect.emit()
