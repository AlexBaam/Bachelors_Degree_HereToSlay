extends AbilityComponent

class_name DrawDiscardedCardClass

var battle_manager: BattleManager
var discard_pile: DiscardPileClass

const PLAYER_HAND: String = "player_hand"

func _ready() -> void:
	battle_manager = $"../../../GameLogic/BattleManager"
	discard_pile = $"../../../CardPiles/DiscardPile"

func ability_config(number: int) -> void:
	var player: PlayerClass = battle_manager.get_player()
	
	var player_hand: PlayerHand = player.get_child_via_name(PLAYER_HAND)
	
	for n in number:
		if discard_pile.get_discard_pile_size() > 0:
			discard_pile.draw_discarded_card(player_hand)
		else: 
			print("No more cards in the discard pile!")

func enemy_ability_config(number: int, target: Node) -> void:
	var asking_enemy: EnemyClass = battle_manager.get_current_enemy()
	var enemy_hand: EnemyHand = asking_enemy.get_enemy_hand()
	
	for n in number:
		if discard_pile.get_discard_pile_size() > 0:
			discard_pile.enemy_draw_discarded_card(enemy_hand)
		else:
			print("No more cards in the discard pile!")
