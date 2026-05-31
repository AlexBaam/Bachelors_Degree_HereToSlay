extends Node

class_name TurnBasedGen

var card_pile_collider: CollisionShape2D
var discard_pile_collider: CollisionShape2D
var player_hand: PlayerHand
var class_player: PlayerClass
var discard_hand_button: DiscardHandClass
var monster_card_slots: MonsterCardSlots

const PLAYER_HAND: String =  "player_hand"
const DISCARD_HAND_BUTTON: String = "discard_hand"

## Defines when a turn should end based on the number of minimum action points
const NUMBER_OF_ACTION_POINTS: int = 0

## The fixed size of a hand the player gets at the start of the game
const BASE_HAND_SIZE: int = 5

func set_variables(card_pile: CardPileClass, discard_pile: DiscardPileClass, player_received: PlayerClass, monster_card_slots_received: MonsterCardSlots) -> void:
	self.card_pile_collider = card_pile.get_child(1).get_child(0)
	self.discard_pile_collider = discard_pile.get_child(1).get_child(0)
	self.player_hand = player_received.get_child(1)
	self.discard_hand_button = player_received.get_child(4)
	self.class_player = player_received
	self.monster_card_slots = monster_card_slots_received

## Function that starts the opponent's turn by disabling the collider for slots, card pile and discard pile
func disable_player_UI() -> void:
	update_card_pile_collider(true)
	update_discard_pile_collider(true)
	update_cards_collider(true)
	update_cards_in_slots_collider(true)
	update_discard_hand_button_collider(true)
	update_monster_cards(true)

## Function that starts the player's turn by enabling the collider for slots, card pile and discard pile
func enable_player_UI() -> void:
	update_card_pile_collider(false)
	update_discard_pile_collider(false)
	update_cards_collider(false)
	update_cards_in_slots_collider(false)
	update_discard_hand_button_collider(false)
	update_monster_cards(false)

func update_card_pile_collider(value: bool) -> void:
	card_pile_collider.disabled = value

func update_cards_collider(value: bool) -> void:
	for card: CardClass in player_hand.player_hand:
		var collider: CollisionShape2D = card.get_card_collider()
		
		collider.disabled = value

func update_discard_pile_collider(value: bool) -> void:
	discard_pile_collider.disabled = value

func update_cards_in_slots_collider(value: bool) -> void:
	for card: CardClass in class_player.cards_in_slots:
		var collider: CollisionShape2D = card.get_card_collider()
		
		collider.disabled = value

func update_discard_hand_button_collider(value: bool) -> void:
	var button: Button = discard_hand_button.get_child(0)
	button.disabled = value

func update_monster_cards(value: bool) -> void:
	for monster_slot: MonsterSlot in self.monster_card_slots.get_children():
		var monster_card: MonsterCard = monster_slot.monster_card_in_slot
		
		self.update_monster_cards_collider(monster_card, value)

func update_monster_cards_collider(monster_card: MonsterCard, value: bool) -> void:
	var monster_card_area2d: Area2D = monster_card.get_child(1)
	var monster_card_collider: CollisionShape2D = monster_card_area2d.get_child(0)
	monster_card_collider.disabled = value

## Simple function created to be reused whenever I need a wait timer of an exact value.
## The measurement unti is seconds, so wait(1.0) is wait a second.
func wait(timer: Timer, time_to_wait: float) -> void:
	timer.wait_time = time_to_wait
	timer.start()
	await timer.timeout
