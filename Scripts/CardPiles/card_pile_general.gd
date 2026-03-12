extends Node

class_name CardPileGen

func pile_visibility(visibility, card_pile_sprite, card_pile_number) -> void:
	if visibility:
		card_pile_sprite.visible = true
		card_pile_number.visible = true
	else:
		card_pile_sprite.visible = false
		card_pile_number.visible = false
