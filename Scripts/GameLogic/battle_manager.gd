extends Node

class_name BattleManager

@onready var card_pile: CardPileClass = $"../../CardPiles/CardPile"
@onready var discard_pile: DiscardPileClass = $"../../CardPiles/DiscardPile"
@onready var battle_timer: Timer = $"../BattleTimer"

@onready var player: PlayerClass = $"../../Player"
@onready var enemy_1: EnemyClass = $"../../Enemies/Enemy1"
@onready var enemy_2: EnemyClass = $"../../Enemies/Enemy2"
@onready var enemy_3: EnemyClass = $"../../Enemies/Enemy3"

@onready var abillities: AbillityManager = $"../../Abillities"
@onready var card_manager: CardManager = $"../../CardManager"
@onready var monster_card_slots: MonsterCardSlots = $"../../MonsterCardSlots"

@onready var game_over: WinCheckerClass = $"../GameOver"

@onready var monster_manager: MonsterManager = $"../MonsterManager"

@onready var enemy_1_hand: Node2D = enemy_1.get_child(0)
@onready var enemy_2_hand: Node2D = enemy_2.get_child(0)
@onready var enemy_3_hand: Node2D = enemy_3.get_child(0)

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
	
	player.request_player_win_check.connect(game_over.check_player_win)
	
	player.request_ability_activation.connect(abillities.play_abillity)
	player.request_card_unselect.connect(card_manager.unselect_card)
	player.ui_lock_requested.connect(self._on_ui_lock)
	
	player.request_discard_card.connect(self._on_player_discard_card)
	player.request_draw_card.connect(self._on_player_draw_card)
	
	player.request_attack_monster.connect(monster_manager.player_attack)
	player.request_monster_unselect.connect(monster_manager.unselect_monster)
	
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

func _on_ui_lock(is_locked: bool) -> void:
	if is_locked:
		turn_based_gen.disable_player_UI()
	else:
		turn_based_gen.enable_player_UI()

func deal_cards() -> void:
	for i in range(turn_based_gen.BASE_HAND_SIZE):
		card_pile.draw_card(player.get_player_hand())
		
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
			game_over.check_enemy_win(enemy)
			
			enemy.enemy_take_action()
			
			await enemy.action_completed
			
			# Wait almost second before acting for the illusion of thinking
			await turn_based_gen.wait(battle_timer,0.5)
		
		enemy.reset_turn_action_points()
		enemy.reset_played_cards_status()
		
	# End the turn and go to the next opponent
	turn_based_gen.enable_player_UI()
	player.reset_played_cards_status()
	player.reset_player_turn_points_with_texture_update()

func check_player_turn() -> void:
	if turn_based_gen.NUMBER_OF_ACTION_POINTS == player.get_action_points_left():
		print("The player's turn ended!")
		emit_signal("end_player_turn")
		player.reset_player_turn_points_without_texture_update()

func get_current_enemy() -> EnemyClass:
	return self.current_enemy

func _on_player_discard_card(card: CardClass) -> void:
	var discard_pos: Vector2 = discard_pile.get_discard_pile_position()
	card.animate_card_to_position(card, discard_pos, card.DEFAULT_CARD_MOVE_SPEED)
	discard_pile.add_to_discard_pile(card)

func _on_player_draw_card() -> void:
	card_pile.draw_card(player.get_player_hand())
