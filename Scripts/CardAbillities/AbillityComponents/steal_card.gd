extends AbilityComponent
class_name StealCardClass

func ability_config(number: int, user: Node, target: Node) -> void:
	var user_hand: Node = null
	var target_hand: Node = null
	
	if user is PlayerClass:
		user_hand = user.get_player_hand()
	elif user is EnemyClass:
		user_hand = user.get_enemy_hand()
	
	if target is PlayerClass:
		target_hand = target.get_player_hand()
	elif target is EnemyClass:
		target_hand = target.get_enemy_hand()
	
	for n in number:
		var random_card: CardClass = null
		if target_hand.get_hand_size() > 0:
			if target is PlayerClass:
				random_card = target_hand.get_player_cards_hand().pick_random() 
			elif target is EnemyClass: 
				random_card = target_hand.enemy_hand.pick_random()
			
			target_hand.remove_card_from_hand(random_card, random_card.DEFAULT_CARD_MOVE_SPEED)
			
			if user is PlayerClass:
				random_card.convert_card_functionality("player", true)
			elif user is EnemyClass:
				random_card.convert_card_functionality("enemy", true)
			
			user_hand.add_card_to_hand(random_card, random_card.DEFAULT_CARD_MOVE_SPEED)
