extends Node2D

@onready var play_card_button: Button = $PlayCardButton
@onready var dice: Node2D = $Dice
@onready var card_manager: Node2D = $"../../CardManager"
@onready var player: PlayerClass = $".."

const FAILED_TO_ROLL_DICE = -9999

const PLAYER_HAND: String =  "player_hand"
const ADD_CARD_TO_HAND: int = 1
const DEFAULT_CARD_MOVE_SPEED: float = 0.1

enum actions {SHOW = 1, HIDE = 2, ATTACH = 3, PLAY = 4}

var card_to_play: Node2D

func _ready() -> void:
	hide_button()

func do(action: Array) -> void:
	match action[0]:
		actions.SHOW:
			show_button()
		actions.HIDE:
			hide_button()
		actions.ATTACH:
			var card: Node2D = action[1]
			attach_to_card(card)
		actions.PLAY:
			var card: Node2D = action[1]
			play(card)

func show_button() -> void:
	play_card_button.visible = true
	play_card_button.disabled = false

func hide_button() -> void:
	play_card_button.visible = false
	play_card_button.disabled = true

func _on_play_card_button_pressed() -> void:
	play(card_to_play)

func attach_to_card(card: Node2D) -> void:
	play_card_button.position = Vector2(card.position.x - 23, card.position.y - 90)
	card_to_play = card
	show_button()

func play(card: Node2D) -> void:
	print(card, " is now being played!")
	var result: int = await dice.roll_dice()
	print("Roll result is: ", result)
