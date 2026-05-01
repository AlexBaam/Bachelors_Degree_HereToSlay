extends AbilityComponent

class_name StealCardClass

var choose_enemy: ChooseEnemy
var battle_manager: BattleManager

const PLAYER_HAND: String = "player_hand"

func _ready() -> void:
	choose_enemy = $"../../../GameLogic/ChooseEnemy"
	battle_manager = $"../../../GameLogic/BattleManager"

func steal_card(card: CardClass, enemy_hand: EnemyHand, player_hand: PlayerHand) -> void:
	if card:
		enemy_hand.remove_card_from_hand(card)
		
		card.convert_card_functionality(card)
		
		player_hand.add_card_to_hand(card, card.DEFAULT_CARD_MOVE_SPEED)

func ability_config(number: int) -> void:
	choose_enemy.show_buttons()
	
	await choose_enemy.any_button_pressed
	
	var enemy_to_attack: int = choose_enemy.get_button_pressed()
	
	var enemy: EnemyClass = battle_manager.get_enemy(enemy_to_attack)
	
	var enemy_hand: EnemyHand = enemy.get_enemy_hand()
	
	var player: PlayerClass = battle_manager.get_player()
	
	var player_hand: PlayerHand = player.get_child_via_name(PLAYER_HAND)
	
	for n in number:
		var random_card: CardClass = enemy_hand.enemy_hand.pick_random()
		self.steal_card(random_card, enemy_hand, player_hand)
