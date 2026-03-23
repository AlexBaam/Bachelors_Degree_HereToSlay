extends Node

@onready var end_turn_button: Button = $"../EndTurnButton"
@onready var card_pile: Node2D = $"../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../BattleTimer"

@onready var enemy_1_hand: Node2D = $"../GameHands/Enemy1Hand"
@onready var player_hand: Node2D = $"../GameHands/PlayerHand"
@onready var card_pile_collision: CollisionShape2D = card_pile.get_child(1).get_child(0)

var turn_points: int
var turn_based_gen: TurnBasedGen = TurnBasedGen.new()

func _ready() -> void:
	battle_timer.one_shot = true
	battle_timer.wait_time = 1.0
	
	for i in range(turn_based_gen.BASE_HAND_SIZE):
		card_pile.draw_card(player_hand)
		card_pile.enemy_draw_card(enemy_1_hand)
	
func _on_end_turn_button_pressed() -> void:
	opponent_turn()

func opponent_turn() -> void:
	turn_based_gen.start_opponent_turn(end_turn_button, card_pile_collision)
	
	turn_points = 0
	
	# Wait a second before drawing a card for the illusion of thinking
	battle_timer.start()
	await battle_timer.timeout
	
	while(turn_based_gen.NUMBER_OF_ACTION_POINTS != turn_points):
		if(card_pile.game_card_pile.size() <= 0):
			break
		
		card_pile.enemy_draw_card(enemy_1_hand)
		
		# Wait a second after drawing a card to make the enemy seem like he is thinking
		battle_timer.start()
		await battle_timer.timeout
		
		# Modify the number of turn points this turn
		turn_points = turn_points + 1
		
		# Play the first card in hand
		
	# End the turn and go to the next opponent
	turn_based_gen.start_player_turn(end_turn_button, card_pile_collision)
