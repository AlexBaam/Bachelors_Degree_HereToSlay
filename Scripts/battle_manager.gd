extends Node

@onready var end_turn_button: Button = $"../EndTurnButton"
@onready var card_pile: Node2D = $"../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../BattleTimer"

@onready var enemy_1_hand: Node2D = $"../GameHands/Enemy1Hand"
@onready var player_hand: Node2D = $"../GameHands/PlayerHand"
@onready var card_pile_collision = card_pile.get_child(1).get_child(0)

const BASE_HAND_SIZE: int = 5

func _ready() -> void:
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	for i in range(BASE_HAND_SIZE):
		card_pile.draw_card(player_hand)
		card_pile.enemy_draw_card(enemy_1_hand)
	
func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn():
	end_turn_button.disabled = true
	end_turn_button.visible = false
	card_pile_collision.disabled = true
	
	card_pile.enemy_draw_card(enemy_1_hand)
	
	# Wait a second after drawing a card to make the enemy seem like he is thinking
	battle_timer.start()
	await battle_timer.timeout
	
	# Play the first card in hand
	
	# End the turn and go to the next opponent
	end_turn_button.disabled = false
	end_turn_button.visible = true
