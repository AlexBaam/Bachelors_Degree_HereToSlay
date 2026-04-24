extends Node

@onready var card_pile: Node2D = $"../../CardPiles/CardPile"
@onready var discard_pile: Node2D = $"../../CardPiles/DiscardPile"
@onready var battle_timer: Timer = $"../BattleTimer"
@onready var player: PlayerClass = $"../../Player"
@onready var enemy_1: EnemyClass = $"../../Enemy1"
@onready var card_manager: Node2D = $"../../CardManager"

@onready var enemy_1_hand: Node2D = enemy_1.get_child(0)
@onready var player_hand: Node2D = player.get_child(0)

const action_points_name: String = "action_points"
const player_hand_name: String =  "player_hand"
enum {RESET = 1, RESETT = 2}

var turn_points_remaining: int

var turn_based_gen: TurnBasedGen = TurnBasedGen.new()

signal end_player_turn

func _process(delta: float) -> void:
	check_player_turn()

func _ready() -> void:
	turn_based_gen.set_variables(card_pile, discard_pile, player)
	
	# Making sure the player cannot interact with the game until he got the cards in his hand
	turn_based_gen.disable_player_UI()
	battle_timer.one_shot = true
	
	# Giving cards to each player
	for i in range(turn_based_gen.BASE_HAND_SIZE):
		card_pile.draw_card(player_hand)
		
		await turn_based_gen.wait(battle_timer,0.2)
		
		card_pile.enemy_draw_card(enemy_1_hand)
		
		await turn_based_gen.wait(battle_timer,0.2)
	
	# Waiting half a second before the game actually starts
	await turn_based_gen.wait(battle_timer,0.5)
	
	# Letting the player start his turn
	turn_based_gen.enable_player_UI()
	
func _on_end_player_turn() -> void:
	card_manager.unselect_card()
	opponent_turn()

func opponent_turn() -> void:
	turn_based_gen.disable_player_UI()
	
	turn_points_remaining = 3
	
	# Wait a second before drawing a card for the illusion of thinking
	await turn_based_gen.wait(battle_timer,1.0)
	
	while(turn_based_gen.NUMBER_OF_ACTION_POINTS != turn_points_remaining):
		turn_points_remaining = enemy_1.enemy_take_action(card_pile, turn_points_remaining)
		
		# Wait a second before drawing a card for the illusion of thinking
		await turn_based_gen.wait(battle_timer,1.0)
		
	# End the turn and go to the next opponent
	turn_based_gen.enable_player_UI()
	player.call_child(action_points_name, [RESETT])

func check_player_turn() -> void:
	if turn_based_gen.NUMBER_OF_ACTION_POINTS == player.get_action_points_left():
		print("The player's turn ended!")
		emit_signal("end_player_turn")
		player.call_child(action_points_name, [RESET])
