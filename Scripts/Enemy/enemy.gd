extends Node

class_name EnemyClass

const SMALL_CARD_SCALE = 1.0
const CARD_MOVE_SPEED = 0.2

var enemy_hand: EnemyHand
var enemy_slots: Node2D

var cards_played_by_opponent: Array[CardClass] = []

@onready var enemies: Node = $".."
@onready var player: PlayerClass = $"../../Player"

var all_possible_enemies: Array

func _ready() -> void:
	define_enemy_components()
	define_possible_enemies()

func define_possible_enemies() -> void:
	all_possible_enemies.append(player)
	
	var enemies_of_type_enemy: Array = enemies.get_children()
	
	for enemy: EnemyClass in enemies_of_type_enemy:
		if enemy != self:
			all_possible_enemies.append(enemy)
	
	print("All the enemies of " + str(self) + " are " + str(all_possible_enemies))

func define_enemy_components() -> void:
	var enemy_components: Array = get_children()
	
	enemy_hand = enemy_components[0]
	enemy_slots	= enemy_components[1]

func enemy_take_action(card_pile: CardPileClass, turn_points_remaining: int) -> int:
	var random_number: float = randf()
	var action_cost: int
	
	if random_number > 0.5:
		# Draw a card
		if self.enemy_draw_card(card_pile):
			action_cost = 1
			turn_points_remaining = turn_points_remaining - action_cost
	else: 
		# Play the first card in hand
		if self.enemy_play_card():
			action_cost = 1
			turn_points_remaining = turn_points_remaining - action_cost
			
	return turn_points_remaining

func enemy_draw_card(card_pile: CardPileClass) -> bool: 
	if(card_pile.get_card_pile_size() <= 0):
		return false
		
	card_pile.enemy_draw_card(enemy_hand)
	return true

func update_enemy_cards_in_party(card_played: CardClass) -> void:
	cards_played_by_opponent.append(card_played)
	print(cards_played_by_opponent)

func enemy_play_card() -> bool:
	# Verificam daca inamicul are carti in mana
	if enemy_hand.enemy_hand.size() == 0:
		return false
		
	# Verificam daca avem slots ptr cartiile inamicului
	if enemy_hand.empty_enemy_slots.size() == 0:
		return false
	
	# Obtinem un slot random dintre cele ale inamicului in care sa punem cartea
	var random_empty_enemy_slot: Node2D = enemy_hand.empty_enemy_slots.pick_random()
	enemy_hand.empty_enemy_slots.erase(random_empty_enemy_slot)
	
	# Play the first card in hand
	var card_to_play: CardClass = enemy_hand.enemy_hand[0]
	
	# Animate card into position
	var tween: Tween = enemy_hand.get_tree().create_tween()
	tween.tween_property(card_to_play, "position", Vector2(random_empty_enemy_slot.global_position.x, random_empty_enemy_slot.global_position.y), CARD_MOVE_SPEED)
	
	# Animate card scale
	var tween2: Tween = enemy_hand.get_tree().create_tween()
	tween2.tween_property(card_to_play, "scale", Vector2(SMALL_CARD_SCALE, SMALL_CARD_SCALE), CARD_MOVE_SPEED)
	
	# Animate card flip using existing animation
	card_to_play.get_node("CardFlipAnimation").play("card_flip")
	
	enemy_hand.remove_card_from_hand(card_to_play)
	
	# Add the card that the opponent played so we know it is on the battlefield
	cards_played_by_opponent.append(card_to_play)
	
	print(cards_played_by_opponent)
	
	return true

func get_enemy_hand() -> EnemyHand:
	return self.get_child(0)

func remove_card_from_party(card_to_remove: CardClass) -> void:
		cards_played_by_opponent.erase(card_to_remove)
		print(cards_played_by_opponent)
