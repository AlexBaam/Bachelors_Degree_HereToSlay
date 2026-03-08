extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2
const DEFAULT_CARD_MOVE_SPEED = 0.1

var card_dragged
var screen_size
var is_hovering_on_card

var player_hand_reference
var input_manager_reference

@export var card_scale: float = 1
@export var hovered_card_scale: float = 1.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	player_hand_reference = $"../PlayerHand"
	input_manager_reference = $"../InputManager"
	input_manager_reference.connect("left_mouse_button_released", on_left_click_released)

func on_left_click_released():
	if card_dragged:
		finish_drag()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_dragged:
		var mouse_position = get_global_mouse_position()
		card_dragged.position = Vector2(clamp(mouse_position.x, 0, screen_size.x),
		clamp(mouse_position.y, 0, screen_size.y))

func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters. position = get_global_mouse_position()
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

func connect_card_signals(card):
	card.connect("hovered", on_hover_over_card)
	card.connect("hovered_off", on_hover_off_card)

func on_hover_over_card(card):
	if not is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)

func on_hover_off_card(card):
	if not card_dragged:
		#If I am not dragging a card
		highlight_card(card, false)
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

func start_drag(card):
	card_dragged = card
	card.scale = Vector2(card_scale, card_scale)

func finish_drag():
	card_dragged.scale = Vector2(hovered_card_scale, hovered_card_scale)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		#Card dropped over the slot and the slot is empty
		player_hand_reference.remove_card_from_hand(card_dragged)
		card_dragged.position = card_slot_found.position
		card_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_slot_found.card_in_slot = true
	else: 
		player_hand_reference.add_card_to_hand(card_dragged, DEFAULT_CARD_MOVE_SPEED)
	card_dragged = null

func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(hovered_card_scale, hovered_card_scale)
		card.z_index = 2
	else:
		card.scale = Vector2(card_scale, card_scale)
		card.z_index = 1
