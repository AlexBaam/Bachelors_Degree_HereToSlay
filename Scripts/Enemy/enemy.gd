extends Node

class_name EnemyClass

const SMALL_CARD_SCALE = 1.0
const CARD_MOVE_SPEED = 0.2

var enemy_hand: EnemyHand
var enemy_slots: Node2D
var enemy_state_machine: EnemyStateMachine

var cards_played_by_opponent: Array[CardClass] = []

var monsters_slayed: int

@onready var enemies: Node = $".."
@onready var player: PlayerClass = $"../../Player"
@onready var state_machine: EnemyStateMachine = $StateMachine
@onready var enemy_card_player: EnemyCardPlayer = $EnemyCardPlayer

var all_possible_enemies: Array
var turn_points_remaining: int

signal action_completed

func _ready() -> void:
	self.define_possible_enemies()
	self.define_enemy_components()
	
	self.reset_slayed_monsters_number()
	self.reset_turn_action_points()

##This method defines all the possible enemies that this enemy instance can have including the player.
##The information is saved in a typeless array that is a local variable called all_possible_enemies.
func define_possible_enemies() -> void:
	all_possible_enemies.append(player)
	
	var enemies_of_type_enemy: Array = enemies.get_children()
	
	for enemy: EnemyClass in enemies_of_type_enemy:
		if enemy != self:
			all_possible_enemies.append(enemy)
	
	print("All the enemies of " + str(self) + " are " + str(all_possible_enemies))

## This method returns all_possible_enemies array that contains all the enemies of this enemy instance.
func get_all_possible_enemies() -> Array:
	return all_possible_enemies

## This method defines every component of the enemy and adds it to their coresponding variable.
func define_enemy_components() -> void:
	var enemy_components: Array = get_children()
	
	enemy_hand = enemy_components[0]
	enemy_slots = enemy_components[1]
	enemy_state_machine = enemy_components[2]

func enemy_take_action() -> void:
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "computing")

func enemy_draw_card(card_pile: CardPileClass) -> bool: 
	if(card_pile.get_card_pile_size() <= 0):
		return false
		
	card_pile.enemy_draw_card(enemy_hand)
	return true

func update_enemy_cards_in_party(card_played: CardClass) -> void:
	cards_played_by_opponent.append(card_played)
	print(cards_played_by_opponent)

func enemy_play_card(card: CardClass, where_from: String, target: Node) -> bool:
	var success: bool = false
	match where_from:
		"hand":
			success = await self.enemy_play_card_from_hand(card, target)
		"party": 
			success = await self.enemy_play_card_from_party(card, target)
	
	return success

func enemy_play_card_from_party(card: CardClass, target: Node) -> bool:
	await enemy_card_player.play(card, target)
	return true

func enemy_play_card_from_hand(card: CardClass, target: Node) -> bool:
	# Verificam daca inamicul are carti in mana
	if enemy_hand.enemy_hand.size() == 0:
		return false
		
	# Verificam daca avem slots ptr cartiile inamicului
	if enemy_hand.empty_enemy_slots.size() == 0:
		return false
	
	# Obtinem un slot random dintre cele ale inamicului in care sa punem cartea
	var random_empty_enemy_slot: SlotClass = enemy_hand.empty_enemy_slots.pick_random()
	enemy_hand.empty_enemy_slots.erase(random_empty_enemy_slot)
	random_empty_enemy_slot.card_in_slot = true
	
	# Play the first card in hand
	var card_to_play: CardClass = card
	
	card_to_play.slot_of_the_card = random_empty_enemy_slot
	
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
	
	await enemy_card_player.play(card_to_play, target)
	
	return true

func get_enemy_hand() -> EnemyHand:
	return self.get_child(0)

func remove_card_from_party(card_to_remove: CardClass) -> void:
		cards_played_by_opponent.erase(card_to_remove)
		
		var slot: SlotClass = card_to_remove.slot_of_the_card
		
		slot.card_in_slot = false
		
		enemy_hand.add_slot_to_empty_slots(slot)
		
		card_to_remove.slot_of_the_card = null
		
		print(cards_played_by_opponent)

## This method sets back to the inital value the number of action points usable in a turn
func reset_turn_action_points() -> void:
	self.turn_points_remaining = 3

## This method resets back to zero the number of monsters slayed in a game by the enemy
func reset_slayed_monsters_number() -> void:
	self.monsters_slayed = 0

func get_party_size() -> int:
	return cards_played_by_opponent.size()

func get_diverse_party_size() -> int:
	var party_classes: Array[String]
	
	for card: CardClass in cards_played_by_opponent:
		var hero_class: String = card.card_class
		if hero_class not in party_classes:
			party_classes.append(hero_class)
	
	var number_of_different_classes: int = party_classes.size()
	
	return number_of_different_classes

func get_slayed_monsters_number() -> int:
	return self.monsters_slayed

func get_action_points() -> int:
	return turn_points_remaining

func get_hand_size() -> int:
	return enemy_hand.get_hand_size()

func get_cards_in_hand() -> Array[CardClass]:
	return self.enemy_hand.get_cards_in_hand().duplicate(true)

func get_enemy_slots() -> Array[SlotClass]:
	var slots: Array[SlotClass] = []
	for slot: SlotClass in self.enemy_slots.get_children():
		slots.append(slot)
	
	return slots

func reset_played_cards_status() -> void:
	for card: CardClass in self.cards_played_by_opponent:
		card.card_played_this_turn = false
