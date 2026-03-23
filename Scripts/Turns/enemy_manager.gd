extends Node

class_name EnemyManager

const SMALL_CARD_SCALE = 1.0
const CARD_MOVE_SPEED = 0.2

func enemy_draw_card(card_pile, enemy_hand) -> bool: 
	if(card_pile.game_card_pile.size() <= 0):
		return false
		
	card_pile.enemy_draw_card(enemy_hand)
	return true

func enemy_play_card(enemy_hand) -> bool:
	# Verificam daca inamicul are carti in mana
	if enemy_hand.enemy_hand.size() == 0:
		return false
		
	# Verificam daca avem slots ptr cartiile inamicului
	if enemy_hand.empty_enemy_slots.size() == 0:
		return false
	
	# Obtinem un slot random dintre cele ale inamicului in care sa punem cartea
	var random_empty_enemy_slot = enemy_hand.empty_enemy_slots.pick_random()
	enemy_hand.empty_enemy_slots.erase(random_empty_enemy_slot)
	
	# Play the first card in hand
	var card_to_play = enemy_hand.enemy_hand[0]
	
	# Animate card into position
	var tween = enemy_hand.get_tree().create_tween()
	tween.tween_property(card_to_play, "position", random_empty_enemy_slot.global_position, CARD_MOVE_SPEED)
	
	# Animate card scale
	var tween2 = enemy_hand.get_tree().create_tween()
	tween2.tween_property(card_to_play, "scale", Vector2(SMALL_CARD_SCALE, SMALL_CARD_SCALE), CARD_MOVE_SPEED)
	
	# Animate card flip using existing animation
	card_to_play.get_node("CardFlipAnimation").play("card_flip")
	
	enemy_hand.remove_card_from_hand(card_to_play)
	
	return true
