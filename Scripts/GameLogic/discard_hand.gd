extends Node2D

class_name DiscardHandClass

@onready var player: PlayerClass = $".."
@onready var discard_pile: DiscardPileClass = $"../../CardPiles/DiscardPile"
@onready var card_pile: CardPileClass = $"../../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../../GameLogic/BattleTimer"

var turn_based_gen: TurnBasedGen = TurnBasedGen.new()

const ACTION_POINTS: String = "action_points"
const PLAYER_HAND: String =  "player_hand"
const ACTION_COST: int = 3

signal removed_cards_from_hand
signal added_cards_to_hand

enum actions {UPDATE = 3}

func _ready() -> void:
	turn_based_gen.set_variables(card_pile, discard_pile, player)

func _on_discard_hand_button_pressed() -> void:
	var action_points: ActionPoints = player.get_child_via_name(ACTION_POINTS)
	var hand: PlayerHand = player.get_child_via_name(PLAYER_HAND)
	
	if action_points.check_action_possibility(ACTION_COST):
		turn_based_gen.disable_player_UI()
		
		remove_old_cards_from_hand(hand)
		
		await self.removed_cards_from_hand
		
		add_new_cards_to_hand(hand)
		
		await self.added_cards_to_hand
		
		await turn_based_gen.wait(battle_timer, 1.0)
		
		player.call_child(ACTION_POINTS, [actions.UPDATE, 3])
		
		turn_based_gen.enable_player_UI()
	else:
		print("Cannot do this action! Not enough action points!")

func remove_old_cards_from_hand(hand: PlayerHand) -> void:
	for card: CardClass in hand.player_hand:
		await turn_based_gen.wait(battle_timer, 0.5)
		
		var discard_pile_position: Vector2 = discard_pile.get_discard_pile_position()
		
		card.animate_card_to_position(card, discard_pile_position, card.DEFAULT_CARD_MOVE_SPEED)
		discard_pile.add_to_discard_pile(card)
	
	hand.remove_every_card_from_hand()
	emit_signal("removed_cards_from_hand")

func add_new_cards_to_hand(hand: PlayerHand) -> void:
	for iterator: int in 5:
		await turn_based_gen.wait(battle_timer, 0.5)
		card_pile.draw_card(hand)
	
	emit_signal("added_cards_to_hand")
