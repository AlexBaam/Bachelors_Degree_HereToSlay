extends Node2D

signal hovered
signal hovered_off

var in_hand_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#All the cards must be a child of a card manager or this will break
	get_parent().connect_card_signals(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# We emit a signal when we hover over the card (this will help us animate the size increse)
func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

# We emit a signal when we hover off the card (this will help us animate the size decrease)
func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
