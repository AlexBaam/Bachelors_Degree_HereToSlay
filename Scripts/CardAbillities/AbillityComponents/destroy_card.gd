extends Node

class_name DestroyCard

@onready var choose_enemy: ChooseEnemy = $GameLogic/ChooseEnemy
@onready var battle_manager: BattleManager = $GameLogic/BattleManager
@onready var discard_pile: DiscardPile = $CardPiles/DiscardPile

func destroy_card(card: Card, enemy: EnemyClass) -> void:
	enemy.remove_card_from_party(card)
	
	card.animate_card_to_position(card, discard_pile.get_discard_pile_position(), card.DEFAULT_CARD_MOVE_SPEED)
	
	discard_pile.add_to_discard_pile(card)

func destroy_multiple_cards(number: int) -> void:
	choose_enemy.show_buttons()
	
	await choose_enemy.any_button_pressed
	
	var enemy_to_attack: int = choose_enemy.get_button_pressed()
	
	var enemy: EnemyClass = battle_manager.get_enemy(enemy_to_attack)
	
	for n in number:
		var random_card: Card = enemy.cards_played_by_opponent.pick_random()
		self.destroy_card(random_card, enemy)
