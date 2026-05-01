extends AbilityComponent

class_name DestroyCardClass

var choose_enemy: ChooseEnemy
var battle_manager: BattleManager
var discard_pile: DiscardPile

func _ready() -> void:
	choose_enemy = $"../../../GameLogic/ChooseEnemy"
	battle_manager = $"../../../GameLogic/BattleManager"
	discard_pile = $"../../../CardPiles/DiscardPile"
	print("READY")

func destroy_card(card: CardClass, enemy: EnemyClass) -> void:
	if card:
		card.animate_card_to_position(card, discard_pile.get_discard_pile_position(), card.DEFAULT_CARD_MOVE_SPEED)
		
		enemy.remove_card_from_party(card)
		
		discard_pile.add_to_discard_pile(card)

func ability_config(number: int) -> void:
	choose_enemy.show_buttons()
	
	await choose_enemy.any_button_pressed
	
	var enemy_to_attack: int = choose_enemy.get_button_pressed()
	
	var enemy: EnemyClass = battle_manager.get_enemy(enemy_to_attack)
	
	for n in number:
		var random_card: CardClass = enemy.cards_played_by_opponent.pick_random()
		self.destroy_card(random_card, enemy)
