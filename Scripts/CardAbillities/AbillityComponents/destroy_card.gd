extends AbilityComponent
class_name DestroyCardClass

func ability_config(number: int, _user: Node, target: Node) -> void:
	for n in number:
		var target_cards: Array[CardClass] = []
		
		if target is PlayerClass:
			target_cards = target.cards_in_slots
		elif target is EnemyClass:
			target_cards = target.cards_played_by_opponent
			
		if target_cards.size() > 0:
			var random_card: CardClass = target_cards.pick_random()
			
			random_card.animate_card_to_position(random_card, discard_pile.get_discard_pile_position(), random_card.DEFAULT_CARD_MOVE_SPEED)
			
			if target is PlayerClass:
				target.remove_card_from_player_party(random_card)
			elif target is EnemyClass:
				target.remove_card_from_party(random_card)
			
			discard_pile.add_to_discard_pile(random_card)
