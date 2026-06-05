extends AbilityComponent

class_name RecruitCardClass

var choose_enemy: ChooseEnemy
var battle_manager: BattleManager

const PLAYER_CARD_SLOTS: String = "player_card_slots"

func _ready() -> void:
	choose_enemy = $"../../../GameLogic/ChooseEnemy"
	battle_manager = $"../../../GameLogic/BattleManager"

func recruit(card: CardClass, enemy: EnemyClass, player: PlayerClass, empty_player_slots: Array[SlotClass]) -> void:
	if card:
		enemy.remove_card_from_party(card)
		
		var slot: SlotClass = empty_player_slots.pick_random()
		
		slot.card_in_slot = true
		
		card.animate_card_to_position(card, slot.position, card.DEFAULT_CARD_MOVE_SPEED)
		
		card.convert_card_functionality(card)
		
		card.slot_of_the_card = slot
		
		player.add_card_to_player_party(card)

func enemy_recruit(card: CardClass, enemy: Node, who_is_recruiting: EnemyClass, empty_player_slots: Array[SlotClass]) -> void:
	if card:
		if enemy is PlayerClass:
			enemy.remove_card_from_player_party(card)
		elif enemy is EnemyClass:
			enemy.remove_card_from_party(card)
		
		var slot: SlotClass = empty_player_slots.pick_random()
		
		slot.card_in_slot = true
		
		card.animate_card_to_position(card, slot.position, card.DEFAULT_CARD_MOVE_SPEED)
		
		if enemy is PlayerClass:
			card.convert_card_functionality(card)
		
		card.slot_of_the_card = slot
		
		who_is_recruiting.add_card_to_enemy_party(card)

func ability_config(number: int) -> void:
	choose_enemy.show_buttons()
	
	await choose_enemy.any_button_pressed
	
	var enemy_to_attack: int = choose_enemy.get_button_pressed()
	
	var enemy: EnemyClass = battle_manager.get_enemy(enemy_to_attack)
	
	var player: PlayerClass = battle_manager.get_player()
	
	var player_slots: PlayerCardSlotsClass = player.get_child_via_name(PLAYER_CARD_SLOTS)
	
	var empty_player_slots: Array[SlotClass] = player_slots.get_empty_slots()
	
	for n in number:
		if enemy.cards_played_by_opponent.size() > 0 and empty_player_slots.size() > 0:
			var random_card: CardClass = enemy.cards_played_by_opponent.pick_random()
			if random_card:
				self.recruit(random_card, enemy, player, empty_player_slots)

func enemy_ability_config(number: int, target: Node) -> void:
	var current_enemy: EnemyClass = battle_manager.get_current_enemy()
	var player: PlayerClass = null
	var enemy: EnemyClass = null
	
	if target is PlayerClass:
		player = target
		
		for n in number:
			var enemy_slots: Array[SlotClass] = current_enemy.get_enemy_slots()
			var empty_slots: Array[SlotClass] = []
			for slot: SlotClass in enemy_slots:
				if slot.card_in_slot == false:
					empty_slots.append(slot)
			
			if player.cards_in_slots.size() > 0 and empty_slots.size() > 0:
				var random_card: CardClass = player.cards_in_slots.pick_random()
				self.enemy_recruit(random_card, player, current_enemy, empty_slots)
			
	elif target is EnemyClass:
		enemy = target
		
		for n in number:
			var enemy_slots: Array[SlotClass] = current_enemy.get_enemy_slots()
			var empty_slots: Array[SlotClass] = []
			for slot: SlotClass in enemy_slots:
				if slot.card_in_slot == false:
					empty_slots.append(slot)
			
			if enemy.cards_played_by_opponent.size() > 0 and empty_slots.size() > 0:
				var random_card: CardClass = enemy.cards_played_by_opponent.pick_random()
				self.enemy_recruit(random_card, enemy, current_enemy, empty_slots)
