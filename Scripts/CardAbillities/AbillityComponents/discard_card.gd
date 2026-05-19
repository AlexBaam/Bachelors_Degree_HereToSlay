extends AbilityComponent

class_name DiscardCardClass

var choose_enemy: ChooseEnemy
var battle_manager: BattleManager
var discard_pile: DiscardPileClass

func _ready() -> void:
	choose_enemy = $"../../../GameLogic/ChooseEnemy"
	battle_manager = $"../../../GameLogic/BattleManager"
	discard_pile = $"../../../CardPiles/DiscardPile"

func discard_card(card: CardClass, enemy_hand: EnemyHand) -> void:
	if card:
		card.animate_card_to_position(card, discard_pile.get_discard_pile_position(), card.DEFAULT_CARD_MOVE_SPEED)
		
		enemy_hand.remove_card_from_hand(card)
		
		discard_pile.add_to_discard_pile(card)

func ability_config(number: int) -> void:
	choose_enemy.show_buttons()
	
	await choose_enemy.any_button_pressed
	
	var enemy_to_attack: int = choose_enemy.get_button_pressed()
	
	var enemy: EnemyClass = battle_manager.get_enemy(enemy_to_attack)
	
	var enemy_hand: EnemyHand = enemy.get_enemy_hand()
	
	for n in number:
		var random_card: CardClass = enemy_hand.enemy_hand.pick_random()
		self.discard_card(random_card, enemy_hand)
