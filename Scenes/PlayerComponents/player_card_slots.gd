extends Node2D

class_name PlayerCardSlotsClass

func get_empty_slots() -> Array:
	var all_slots: Array = get_children()
	var empty_slots: Array[SlotClass]
	
	for slot: SlotClass in all_slots:
		if slot.card_in_slot == false:
			empty_slots.append(slot)
	
	return empty_slots
