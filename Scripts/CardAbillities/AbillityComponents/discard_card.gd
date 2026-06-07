extends AbilityComponent
class_name DiscardCardClass

func ability_config(number: int, _user: Node, target: Node) -> void:
	var target_hand: Node = null
	if target is PlayerClass:
		target_hand = target.get_player_hand() 
	elif target is EnemyClass:
		target_hand = target.get_enemy_hand()
	
	for n in number:
		var hand_cards: Array[CardClass] = []
		if target is PlayerClass:
			hand_cards = target_hand.get_player_cards_hand()
		elif target is EnemyClass:
			hand_cards = target_hand.enemy_hand
		
		if hand_cards.size() > 0:
			var random_card: CardClass = hand_cards.pick_random()
			
			random_card.animate_card_to_position(random_card, discard_pile.get_discard_pile_position(), random_card.DEFAULT_CARD_MOVE_SPEED)
			
			if target is PlayerClass:
				target_hand.remove_card_from_hand(random_card, 0.1) # Assuming 0.1 is your default speed
			elif target is EnemyClass:
				target_hand.remove_card_from_hand(random_card)
				
			discard_pile.add_to_discard_pile(random_card)
