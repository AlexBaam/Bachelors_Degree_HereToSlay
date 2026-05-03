extends Node2D

@onready var player: PlayerClass = $"../Player"
@onready var discard_pile: DiscardPile = $"../CardPiles/DiscardPile"
@onready var card_pile: CardPileClass = $"../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../GameLogic/BattleTimer"

var turn_based_gen: TurnBasedGen = TurnBasedGen.new()

const ACTION_POINTS: String = "action_points"
const PLAYER_HAND: String =  "player_hand"

enum actions {UPDATE = 3}

signal hand_discarded

func _on_discard_hand_button_pressed() -> void:
	var hand: PlayerHand = player.get_child_via_name(PLAYER_HAND)
	
	remove_old_cards_from_hand(hand)
	
	add_new_cards_to_hand(hand)
	
	await turn_based_gen.wait(battle_timer, 1.0)
	
	emit_signal("hand_discarded")

func remove_old_cards_from_hand(hand: PlayerHand) -> void:
	for card: CardClass in hand.player_hand:
		hand.remove_card_from_hand(card)
		discard_pile.add_to_discard_pile(card)

func add_new_cards_to_hand(hand: PlayerHand) -> void:
	for iterator: int in 5:
		await turn_based_gen.wait(battle_timer, 0.5)
		card_pile.draw_card(hand)

func _on_hand_discarded() -> void:
	player.call_child(ACTION_POINTS, [actions.UPDATE, 3])
