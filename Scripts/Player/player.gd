extends Node

class_name PlayerClass

#ON THE INSIDE
@onready var player_slots: PlayerCardSlotsClass = $PlayerCardSlots
@onready var player_hand: PlayerHand = $PlayerHand
@onready var action_points: ActionPoints = $ActionPoints
@onready var card_player: CardPlayer = $CardPlayer
@onready var discard_hand: DiscardHandClass = $DiscardHand
@onready var monster_slayer: MonsterSlayer = $MonsterSlayer
@onready var dice: DiceClass = $Dice
@onready var choose_enemy: ChooseEnemy = $ChooseEnemy

@export var card_move_speed: float = 0.1 # Cards default speed around the deck

##This signal is a result of the check_win signal from ActionPoints class
signal request_player_win_check(player: PlayerClass)

#SIGNALS THAT WILL SEND FURTHER THE CARD PLAYER REQUESTS
##The card player requests to activate the ability for this class
signal request_ability_activation(card_class: String)
##The card player requests for the card to be unselected
signal request_card_unselect()
##The card player requests for the UI to be locked/unlocked
signal ui_lock_requested(is_locked: bool)

#SIGNALS THAT WILL SEND FURTHER DISCARD HAND REQUESTS
signal request_discard_card(card: CardClass)
signal request_draw_card()

#SIGNALS THAT WILL SEND FURTHER MONSTER SLAYER REQUESTS
signal request_attack_monster(player: PlayerClass, monster: MonsterCard)
signal request_monster_unselect()

## This array represents the party
var cards_in_slots: Array[CardClass] = []

##This variable counts how many monsters the player slayed this match
var monsters_slayed: int 

func _ready() -> void:
	action_points.check_win.connect(self.check_player_win)
	monsters_slayed = 0
	
	card_player.request_ability_use.connect(self._redirect_ability)
	card_player.request_card_unselect.connect(self._redirect_unselect)
	card_player.request_ui_lock.connect(self._redirect_ui_lock)
	
	discard_hand.request_ui_lock.connect(self._redirect_ui_lock)
	discard_hand.request_discard_card.connect(self._redirect_discard_card)
	discard_hand.request_draw_card.connect(self._redirect_draw_card)
	
	monster_slayer.request_attack_monster.connect(self._redirect_attack_monster)
	monster_slayer.request_monster_unselect.connect(self._redirect_monster_unselect)

## This function resets the card played status of the cards in the party after the turn ends
func reset_played_cards_status() -> void: 
	for card: CardClass in cards_in_slots:
		card.card_played_this_turn = false

## This function adds a card to the player party. A party is formed of the cards in the slots that can be played every turn
func add_card_to_player_party(card_played: CardClass) -> void:
	cards_in_slots.append(card_played)
	print(cards_in_slots)

## This method removes a card from the player party. A party is formed of the cards in the slots that can be played every turn
func remove_card_from_player_party(card: CardClass) -> void:
	var slot_of_the_card: SlotClass = card.slot_of_the_card
	if slot_of_the_card:
		slot_of_the_card.card_in_slot = false
		slot_of_the_card.get_node("Area2D/CollisionShape2D").disabled = false
		
	card.slot_of_the_card = null 
	card.card_played_this_turn = false
	
	self.cards_in_slots.erase(card)

## This method returns the size of the player party
func get_party_size() -> int:
	return cards_in_slots.size()

## This method increases the number of monsters slayed by one
func increase_slayed_monsters() -> void:
	self.monsters_slayed = self.monsters_slayed + 1
	print("Monsters slayed so far: ", self.monsters_slayed)

## This method returns the diversity of the players party when it comes to classes
func get_diverse_party_size() -> int:
	var party_classes: Array[String]
	
	for card: CardClass in cards_in_slots:
		var hero_class: String = card.card_class
		if hero_class not in party_classes:
			party_classes.append(hero_class)
	
	var number_of_different_classes: int = party_classes.size()
	
	return number_of_different_classes

##Method that returns the number of monsters slayed by the player this game
func get_slayed_monsters_number() -> int:
	return self.monsters_slayed

# HERE STARTS PLAYER HAND

##Method that adds a card to the player hand
func add_card_to_hand(card: CardClass) -> void:
	self.player_hand.add_card_to_hand(card, self.card_move_speed)

##Method that removes a card from the player hand
func remove_card_from_hand(card_to_remove: CardClass) -> void:
	self.player_hand.remove_card_from_hand(card_to_remove, self.card_move_speed)

func get_player_hand() -> PlayerHand:
	return self.player_hand

##Method that returns the hand size of the player
func get_hand_size() -> int:
	return self.player_hand.get_hand_size()

##Method that returns the cards in the player hand
func get_player_cards_hand() -> Array[CardClass]:
	return self.player_hand.get_player_cards_hand()

# HERE STARTS ACTION POINTS

## This function returns how many action points the player has at that respective moment
func get_action_points() -> ActionPoints:
	return self.action_points

func get_action_points_left() -> int:
	return action_points.get_action_points_left()

func reset_player_turn_points_without_texture_update() -> void:
	self.action_points.reset_player_turn_points_without_texture_update()

func reset_player_turn_points_with_texture_update() -> void:
	self.action_points.reset_player_turn_points_with_texture_update()

func update_player_action_points(points_to_subtract: int) -> void:
	self.action_points.update_player_action_points(points_to_subtract)

#HERE START THE PLAYER CARD SLOTS

func get_empty_card_slots() -> Array[SlotClass]:
	return self.player_slots.get_empty_card_slots()

func get_card_slots() -> Array[SlotClass]:
	return self.player_slots.get_card_slots()

#HERE STARTS THE CARD PLAYER

func play_card(card: CardClass) -> void:
	self.card_player.play(card)

func attach_to_card(card: CardClass) -> void:
	self.card_player.attach_to_card(card)

func hide_button() -> void:
	self.card_player.hide_button()

#HERE START THE DISCARD HAND BUTTON

func get_discard_hand_button() -> DiscardHandClass:
	return self.discard_hand

#HERE START THE DICE CLASS:

## This method returns the dice scene for rolling
func get_dice() -> DiceClass:
	return self.dice

#HERE STARTS THE CHOOSE ENEMY:
func get_choose_enemy() -> ChooseEnemy:
	return self.choose_enemy

#HERE START METHODS FROM MONSTER SLAYER:

func attach_to_monster_card(monster: MonsterCard) -> void:
	self.monster_slayer.attach_to_card(monster)

func hide_attack_monster_button() -> void:
	self.monster_slayer.hide_button()

#METHODS THAT REDIRECT SIGNALS OUTSIDE THE PLAYER CLASS

func check_player_win() -> void:
	request_player_win_check.emit(self)

func _redirect_ability(card_class: String) -> void:
	request_ability_activation.emit(card_class)

func _redirect_unselect() -> void:
	request_card_unselect.emit()

func _redirect_ui_lock(is_locked: bool) -> void:
	ui_lock_requested.emit(is_locked)

func _redirect_discard_card(card: CardClass) -> void:
	request_discard_card.emit(card)

func _redirect_draw_card() -> void:
	request_draw_card.emit()

func _redirect_attack_monster(monster: MonsterCard) -> void:
	request_attack_monster.emit(self, monster)

func _redirect_monster_unselect() -> void:
	request_monster_unselect.emit()
