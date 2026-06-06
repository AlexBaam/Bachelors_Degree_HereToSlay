extends Node2D

class_name DiscardHandClass

@onready var player: PlayerClass = $".."

const ACTION_COST: int = 3

#Signals that make clear when the step is done
signal removed_cards_from_hand
signal added_cards_to_hand

#Signals for external calls
signal request_ui_lock(is_locked: bool)
signal request_discard_card(card: CardClass)
signal request_draw_card()

func _on_discard_hand_button_pressed() -> void:
	var action_points: ActionPoints = player.get_action_points()
	var player_hand: PlayerHand = player.get_player_hand()
	
	if action_points.check_action_possibility(ACTION_COST):
		request_ui_lock.emit(true)
		
		self.remove_old_cards_from_hand(player_hand)
		
		await self.removed_cards_from_hand
		
		self.add_new_cards_to_hand()
		
		await self.added_cards_to_hand
		
		await get_tree().create_timer(1.0).timeout
		
		player.update_player_action_points(ACTION_COST)
		
	else:
		print("Cannot discard the hand! Not enough action points!")

func remove_old_cards_from_hand(hand: PlayerHand) -> void:
	var current_cards: Array[CardClass] = hand.get_player_cards_hand().duplicate()
	
	for card: CardClass in current_cards:
		await get_tree().create_timer(0.5).timeout
		request_discard_card.emit(card) 
	
	hand.remove_every_card_from_hand()
	removed_cards_from_hand.emit()

func add_new_cards_to_hand() -> void:
	for iterator: int in 5:
		await get_tree().create_timer(0.5).timeout
		request_draw_card.emit()
	
	added_cards_to_hand.emit()
