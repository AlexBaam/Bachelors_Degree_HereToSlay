extends Node

class_name BattleManager

const action_points_name: String = "action_points"
const player_hand_name: String =  "player_hand"

@onready var card_pile: Node2D = $"../../CardPiles/CardPile"
@onready var discard_pile: Node2D = $"../../CardPiles/DiscardPile"
@onready var battle_timer: Timer = $"../BattleTimer"
@onready var player: PlayerClass = $"../../Player"
@onready var enemy_1: EnemyClass = $"../../Enemies/Enemy1"
@onready var enemy_2: EnemyClass = $"../../Enemies/Enemy2"
@onready var enemy_3: EnemyClass = $"../../Enemies/Enemy3"
@onready var card_manager: Node2D = $"../../CardManager"
@onready var monster_card_slots: MonsterCardSlots = $"../../MonsterCardSlots"

@onready var enemy_1_hand: Node2D = enemy_1.get_child(0)
@onready var enemy_2_hand: Node2D = enemy_2.get_child(0)
@onready var enemy_3_hand: Node2D = enemy_3.get_child(0)

@onready var player_hand: Node2D = player.get_child_via_name(player_hand_name)

enum {RESET = 1, RESETT = 2}

var enemies: Array

var turn_based_gen: TurnBasedGen = TurnBasedGen.new()

var current_enemy: EnemyClass = null

signal end_player_turn

signal dealt_cards

func _process(delta: float) -> void:
	self.check_player_turn()

func _ready() -> void:
	turn_based_gen.set_variables(card_pile, discard_pile, player, monster_card_slots)
	
	set_enemies()
	
	# Making sure the player cannot interact with the game until he got the cards in his hand
	turn_based_gen.disable_player_UI()
	battle_timer.one_shot = true
	
	# Giving cards to each player
	deal_cards()
	
	# Waiting half a second before the game actually starts
	await turn_based_gen.wait(battle_timer,0.5)
	
	# Letting the player start his turn
	await dealt_cards
	
	turn_based_gen.enable_player_UI()

func deal_cards() -> void:
	for i in range(turn_based_gen.BASE_HAND_SIZE):
		card_pile.draw_card(player_hand)
		
		await turn_based_gen.wait(battle_timer,0.2)
		
		card_pile.enemy_draw_card(enemy_1_hand)
		
		await turn_based_gen.wait(battle_timer,0.2)
		
		card_pile.enemy_draw_card(enemy_2_hand)
		
		await turn_based_gen.wait(battle_timer,0.2)
		
		card_pile.enemy_draw_card(enemy_3_hand)
		
		await turn_based_gen.wait(battle_timer,0.2)
	
	emit_signal("dealt_cards")

func set_enemies() -> void:
	enemies.append(enemy_1)
	enemies.append(enemy_2)
	enemies.append(enemy_3)

func get_enemy(number: int) -> Node:
	return enemies[number - 1]

func get_player() -> PlayerClass:
	return player

func _on_end_player_turn() -> void:
	card_manager.unselect_card()
	opponent_turn()

func opponent_turn() -> void:
	turn_based_gen.disable_player_UI()
	
	for enemy: EnemyClass in enemies:
		self.current_enemy = enemy
		# Wait a bit before acting to give the impression of thinking
		await turn_based_gen.wait(battle_timer,0.7)
		
		while(turn_based_gen.NUMBER_OF_ACTION_POINTS != enemy.turn_points_remaining):
			enemy.enemy_take_action()
			
			await enemy.action_completed
			
			# Wait almost second before acting for the illusion of thinking
			await turn_based_gen.wait(battle_timer,0.5)
		
		enemy.reset_turn_action_points()
		enemy.reset_played_cards_status()
		
	# End the turn and go to the next opponent
	turn_based_gen.enable_player_UI()
	player.reset_played_cards_status()
	player.call_child(action_points_name, [RESETT])

func check_player_turn() -> void:
	if turn_based_gen.NUMBER_OF_ACTION_POINTS == player.get_action_points_left():
		print("The player's turn ended!")
		emit_signal("end_player_turn")
		player.call_child(action_points_name, [RESET])

func get_current_enemy() -> EnemyClass:
	return self.current_enemy
