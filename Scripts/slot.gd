extends Node2D

var card_in_slot : bool = false
@onready var card_rotation: float = rotation

func rotate_card(card) -> void:
	card.rotation = card_rotation
