extends Node

@onready var end_turn_button: Button = $"../EndTurnButton"
@onready var card_pile: Node2D = $"../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../BattleTimer"

@onready var enemy_1_hand: Node2D = $"../GameHands/Enemy1Hand"
@onready var player_hand: Node2D = $"../GameHands/PlayerHand"
@onready var card_pile_collision: CollisionShape2D = card_pile.get_child(1).get_child(0)

var turn_points: int
var turn_based_gen: TurnBasedGen = TurnBasedGen.new()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_manager: EnemyManager = EnemyManager.new()

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
		# Wait a second after drawing a card to make the enemy seem like he is thinking
		battle_timer.start()
		await battle_timer.timeout
		
		var random_number: float = round(rng.randf())
		if random_number == 1.0:
			# Draw a card
			if enemy_manager.enemy_draw_card(card_pile, enemy_1_hand):
				turn_points = turn_points + 1
		else: 
			# Play the first card in hand
			if enemy_manager.enemy_play_card(enemy_1_hand):
				turn_points = turn_points + 1
		
	# End the turn and go to the next opponent
	turn_based_gen.start_player_turn(end_turn_button, card_pile_collision)
