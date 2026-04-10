extends Node2D

@onready var play_card_button: Button = $PlayCardButton

enum actions {SHOW = 1, HIDE = 2, ATTACH = 3}

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

func show_button() -> void:
	play_card_button.visible = true
	play_card_button.disabled = false

func hide_button() -> void:
	play_card_button.visible = false
	play_card_button.disabled = true

func _on_play_card_button_pressed() -> void:
	print("Play button pressed!")

func attach_to_card(card: Node2D) -> void:
	play_card_button.position = Vector2(card.position.x - 23, card.position.y - 90)
	card_to_play = card
	show_button()
