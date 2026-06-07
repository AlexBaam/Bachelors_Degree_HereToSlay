extends AbilityComponent
class_name DrawDiscardedCardClass

func ability_config(number: int, user: Node, _target: Node) -> void:
	var user_hand: Node = null
	if user is PlayerClass:
		user_hand = user.get_player_hand() 
	elif user is EnemyClass:
		user_hand = user.get_enemy_hand()
	
	for n in number:
		if discard_pile.get_discard_pile_size() > 0:
			if user is PlayerClass:
				discard_pile.draw_discarded_card(user_hand)
			else:
				discard_pile.enemy_draw_discarded_card(user_hand)
		else: 
			print("No more cards in the discard pile!")
