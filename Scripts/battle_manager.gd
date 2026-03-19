extends Node

@onready var end_turn_button: Button = $"../EndTurnButton"
@onready var card_pile: Node2D = $"../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../BattleTimer"

@onready var enemy_1_hand: Node2D = $"../GameHands/Enemy1Hand"
@onready var player_hand: Node2D = $"../GameHands/PlayerHand"

@export var starting_player_hand_size: int = 5

func _ready() -> void:
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	for i in range(starting_player_hand_size):
		card_pile.draw_card(player_hand)
		card_pile.enemy_draw_card(enemy_1_hand)
	
func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	end_turn_button.disabled = true
	end_turn_button.visible = false

	card_pile.enemy_draw_card(enemy_1_hand)
	
	# Wait a second after drawing a card to make the enemy seem like he is thinking
	battle_timer.start()
	await battle_timer.timeout
	
	# Play the first card in hand
	
	# End the turn and go to the next opponent
	end_turn_button.disabled = false
	end_turn_button.visible = true
