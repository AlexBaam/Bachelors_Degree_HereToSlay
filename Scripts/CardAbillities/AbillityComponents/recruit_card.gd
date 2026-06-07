extends AbilityComponent
class_name RecruitCardClass

func ability_config(number: int, user: Node, target: Node) -> void:
	for n in number:
		var empty_user_slots: Array[SlotClass] = []
		if user is PlayerClass:
			empty_user_slots = user.get_empty_card_slots()
		elif user is EnemyClass:
			for slot: SlotClass in user.get_enemy_slots():
				if slot.card_in_slot == false:
					empty_user_slots.append(slot)
					
		var target_cards: Array[CardClass] = []
		if target is PlayerClass:
			target_cards = target.cards_in_slots
		elif target is EnemyClass:
			target_cards = target.cards_played_by_opponent
			
		if target_cards.size() > 0 and empty_user_slots.size() > 0:
			var random_card: CardClass = target_cards.pick_random()
			var slot: SlotClass = empty_user_slots.pick_random()
			
			if target is PlayerClass:
				target.remove_card_from_player_party(random_card)
			elif target is EnemyClass:
				target.remove_card_from_party(random_card)
				
			slot.card_in_slot = true
			random_card.animate_card_to_position(random_card, slot.global_position, random_card.DEFAULT_CARD_MOVE_SPEED)
			random_card.slot_of_the_card = slot
			
			if user is PlayerClass:
				random_card.convert_card_functionality("player")
				user.add_card_to_player_party(random_card)
			elif user is EnemyClass:
				random_card.convert_card_functionality("enemy")
				user.add_card_to_enemy_party(random_card)
