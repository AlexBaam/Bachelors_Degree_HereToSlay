extends Node2D

## Signal to define the click of the left mouse button.
signal left_mouse_button_clicked

## Signal to define the release of the left mouse button.
signal left_mouse_button_released

## The collision mask of card scenes.
const COLLISION_MASK_CARD = 1

## The collision mask of the card pile scene, this information can be found in the Area2D's collision from the inspector.
## The layer is equal to 3, bit 2 with a value of 4.
const COLLISION_MASK_CARD_PILE = 4

## The collision mask of the monster slot scene.
const COLLISION_MASK_MONSTER_SLOT = 32

@onready var player_hand: Node2D = $"../GameHands/PlayerHand"
@onready var player: Node = $"../Player"

@onready var card_manager_reference: Node2D = $"../CardManager"
@onready var card_pile_reference: Node2D = $"../CardPiles/CardPile"

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")

func raycast_at_cursor() -> void:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters. position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			# Card clicked
			var card_found = result[0].collider.get_parent()
			if card_found:
				card_manager_reference.card_clicked(card_found)
		elif result_collision_mask == COLLISION_MASK_CARD_PILE:
			# Card pile clicked
			card_pile_reference.draw_card(player_hand)
			player.update_player_action_points(1)
		elif result_collision_mask == COLLISION_MASK_MONSTER_SLOT:
			# Monster slot clicked
			print("You click a monster slot!")
