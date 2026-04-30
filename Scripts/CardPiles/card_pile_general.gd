extends Node

class_name CardPileGenerals

func pile_visibility(visibility: bool, card_pile_sprite: Sprite2D, card_pile_number: RichTextLabel) -> void:
	if visibility:
		card_pile_sprite.visible = true
		card_pile_number.visible = true
	else:
		card_pile_sprite.visible = false
		card_pile_number.visible = false
