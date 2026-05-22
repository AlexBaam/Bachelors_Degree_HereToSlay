extends Node2D

class_name CardPlayer

@onready var play_card_button: Button = $PlayCardButton
@onready var dice: DiceClass = $"../Dice"
@onready var card_manager: Node2D = $"../../CardManager"
@onready var player: PlayerClass = $".."

@onready var card_piles: Node2D = $"../../CardPiles"
@onready var abillity_manager: AbillityManager = $"../../Abillities"

const ACTION_POINTS: String = "action_points"
const UPDATE: int = 3

enum actions {SHOW = 1, HIDE = 2, ATTACH = 3, PLAY = 4}

var card_to_play: CardClass

var turn_gen: TurnBasedGen = TurnBasedGen.new()

func _ready() -> void:
	turn_gen.set_variables(card_piles.get_child(0), card_piles.get_child(1), player)
	hide_button()

func do(action: Array) -> void:
	match action[0]:
		actions.SHOW:
			show_button()
		actions.HIDE:
			hide_button()
		actions.ATTACH:
			var card: CardClass = action[1]
			attach_to_card(card)
		actions.PLAY:
			var card: CardClass = action[1]
			play(card)

func show_button() -> void:
	play_card_button.visible = true
	play_card_button.disabled = false

func hide_button() -> void:
	play_card_button.visible = false
	play_card_button.disabled = true

func _on_play_card_button_pressed() -> void:
	play(card_to_play)
	card_manager.unselect_card()

func attach_to_card(card: CardClass) -> void:
	play_card_button.position = Vector2(card.position.x - 23, card.position.y - 90)
	card_to_play = card
	show_button()

func play(card: CardClass) -> void:
	if card.card_played_this_turn != true:
		print(card, " is now being played!")
		
		print(card.card_dice_roll)
		
		turn_gen.disable_player_UI()
		
		var result: int = await dice.roll_dice()
		print("Roll result is: ", result)
		
		if result >= card.card_dice_roll:
			abillity_manager.play_abillity(card.card_class)
		else: 
			print("Failed to play the cards abillity!")
		
		card.card_played_this_turn = true
		
		player.call_child(ACTION_POINTS, [UPDATE, 1])
		turn_gen.enable_player_UI()
	else:
		print(card, " already played this turn!")
