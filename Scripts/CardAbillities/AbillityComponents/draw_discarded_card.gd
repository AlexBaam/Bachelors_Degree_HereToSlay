extends Node

class_name DrawDiscardedCard

var battle_manager: BattleManager
var discard_pile: DiscardPile

const PLAYER_HAND: String = "player_hand"

func _ready() -> void:
	battle_manager = $"../../../GameLogic/BattleManager"
	discard_pile = $"../../../CardPiles/DiscardPile"

func draw_discarded_cards(number: int) -> void:
	var player: PlayerClass = battle_manager.get_player()
	
	var player_hand: PlayerHand = player.get_child_via_name(PLAYER_HAND)
	
	for n in number:
		if discard_pile.get_discard_pile_size() > 0:
			discard_pile.draw_discarded_card(player_hand)
		else: 
			print("No more cards in the discard pile!")
