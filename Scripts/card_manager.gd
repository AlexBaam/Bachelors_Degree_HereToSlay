extends Node2D

class_name CardManager

const COLLISION_MASK_CARD: int = 1
const COLLISION_MASK_SLOT: int = 2
const COLLISION_MASK_DISCARD_PILE: int = 8
## The default speed for card movement on the screen
const DEFAULT_CARD_MOVE_SPEED: float = 0.1
## Constant to define how much we want to change the card position on the Y axis (vertical)
const SELECTED_CARD_Y_UPDATE: int = 15

var card_dragged: CardClass
var screen_size : Vector2
var is_hovering_on_card: bool
var selected_card: CardClass

@export var card_scale: float = 1.4
@export var smaller_card_scale: float = 1.0
@export var hover_scale_increase: float = 1.2

@onready var player: PlayerClass = $"../Player"
@onready var discard_pile: Node2D = $"../CardPiles/DiscardPile"
@onready var input_manager: Node2D = $"../InputManager"
@onready var card_selection_screen: Node2D = $"../CardSelectionScreen"

const ACTION_POINTS: String = "action_points"
const PLAYER_HAND: String =  "player_hand"
const CARD_PLAY_BUTTON: String = "play_button"
enum {ADD = 1, REMOVE = 3, SHOW = 1, HIDE = 2, ATTACH = 3, PLAY = 4}

func on_left_click_released() -> void:
	if card_dragged:
		finish_drag()

func _ready() -> void:
	screen_size = get_viewport_rect().size
	input_manager.connect("left_mouse_button_released", on_left_click_released)

func _process(delta: float) -> void:
	if card_dragged:
		var mouse_position: Vector2 = get_global_mouse_position()
		card_dragged.position = Vector2(clamp(mouse_position.x, 0, screen_size.x),
		clamp(mouse_position.y, 0, screen_size.y))

func card_clicked(card: CardClass) -> void:
	if card.slot_of_the_card:
		select_card(card)
	else:
		start_drag(card)

func raycast_check_for_card():
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var parameters: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null

func raycast_check_for_card_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters. position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_discard_pile():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters. position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_DISCARD_PILE
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func get_card_with_highest_z_index(cards):
	#I will assume that the first card in the array has the highest z index
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	
	#Loop through the rest of the cards and check if there are higher Z indexes
	#Start from 1 because we can skip the first card as we make the assumtion above
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = highest_z_card.z_index
	return highest_z_card

func start_drag(card: CardClass) -> void:
	unselect_card()
	card_dragged = card
	card.scale = Vector2(card_scale, card_scale)

func finish_drag() -> void:
	card_dragged.scale = Vector2(card_scale * hover_scale_increase,card_scale * hover_scale_increase)
	var card_slot_found = raycast_check_for_card_slot()
	var discard_pile_found = raycast_check_for_discard_pile()
	if card_slot_found and not card_slot_found.card_in_slot:
		#Card dropped over the slot and the slot is empty
		player.call_child(PLAYER_HAND, [REMOVE, card_dragged])
		card_dragged.position = card_slot_found.position
		
		# Adjust card scale after the slot
		card_dragged.slot_of_the_card = card_slot_found
		card_dragged.z_index = -1
		card_dragged.scale = Vector2(smaller_card_scale, smaller_card_scale)
		
		card_slot_found.card_in_slot = true
		card_slot_found.get_node("Area2D/CollisionShape2D").disabled = true
		
		player.add_card_to_player_party(card_dragged)
		
		player.call_child(CARD_PLAY_BUTTON, [PLAY, card_dragged])
	else: 
		player.call_child(PLAYER_HAND, [ADD, card_dragged, DEFAULT_CARD_MOVE_SPEED])
	card_dragged = null

func connect_card_signals(card: Node2D) -> void:
	card.connect("hovered", on_hover_over_card)
	card.connect("hovered_off", on_hover_off_card)

func on_hover_over_card(card: Node2D) -> void:
	if card.slot_of_the_card:
		return
		
	if not is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)

func on_hover_off_card(card: Node2D) -> void:
	# Here we first check if the card is not in a slot
	# Second if we are not dragging a card
	if (!card.slot_of_the_card && !card_dragged):
			highlight_card(card, false)
			var new_card_hovered = raycast_check_for_card()
			if new_card_hovered:
				highlight_card(new_card_hovered, true)
			else:
				is_hovering_on_card = false

func highlight_card(card: Node2D, hovered) -> void:
	if hovered:
		card.scale = Vector2(card_scale * hover_scale_increase, card_scale * hover_scale_increase)
		card.z_index = 2
	else:
		card.scale = Vector2(card_scale, card_scale)
		card.z_index = 1

func select_card(card: CardClass) -> void:
	if selected_card:
		if is_this_card_already_selected(card):
			unselect_card()
		else:
			change_selected_card(card)
	else:
		selected_card = card
		selected_card.position.y -= SELECTED_CARD_Y_UPDATE
		player.call_child(CARD_PLAY_BUTTON, [ATTACH, selected_card])

func unselect_card() -> void:
	if selected_card:
		selected_card.position.y += SELECTED_CARD_Y_UPDATE
		player.call_child(CARD_PLAY_BUTTON, [HIDE])
		selected_card = null

func change_selected_card(card: CardClass) -> void:
	selected_card.position.y += SELECTED_CARD_Y_UPDATE
	selected_card = card
	selected_card.position.y -= SELECTED_CARD_Y_UPDATE
	player.call_child(CARD_PLAY_BUTTON, [ATTACH, selected_card])

func is_this_card_already_selected(card: CardClass) -> bool:
	if selected_card == card:
		return true
	else: 
		return false
