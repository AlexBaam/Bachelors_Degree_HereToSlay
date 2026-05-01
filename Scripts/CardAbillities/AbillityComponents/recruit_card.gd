extends AbilityComponent

class_name RecruitCardClass

var choose_enemy: ChooseEnemy
var battle_manager: BattleManager

const PLAYER_CARD_SLOTS: String = "player_card_slots"

func _ready() -> void:
	choose_enemy = $"../../../GameLogic/ChooseEnemy"
	battle_manager = $"../../../GameLogic/BattleManager"

func recruit(card: CardClass, enemy: EnemyClass, player: PlayerClass, empty_player_slots: Array[SlotClass]) -> void:
	enemy.remove_card_from_party(card)
	
	var slot: SlotClass = empty_player_slots.pick_random()
	
	slot.card_in_slot = true
	
	card.animate_card_to_position(card, slot.position, card.DEFAULT_CARD_MOVE_SPEED)
	
	card.convert_card_functionality(card)
	
	card.slot_of_the_card = slot
	
	player.update_player_cards_in_party(card)

func ability_config(number: int) -> void:
	choose_enemy.show_buttons()
	
	await choose_enemy.any_button_pressed
	
	var enemy_to_attack: int = choose_enemy.get_button_pressed()
	
	var enemy: EnemyClass = battle_manager.get_enemy(enemy_to_attack)
	
	var player: PlayerClass = battle_manager.get_player()
	
	var player_slots: PlayerCardSlotsClass = player.get_child_via_name(PLAYER_CARD_SLOTS)
	
	var empty_player_slots: Array[SlotClass] = player_slots.get_empty_slots()
	
	for n in number:
		var random_card: CardClass = enemy.cards_played_by_opponent.pick_random()
		if random_card:
			self.recruit(random_card, enemy, player, empty_player_slots)
