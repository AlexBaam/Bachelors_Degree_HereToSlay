extends Node2D

class_name PlayerCardSlotsClass

##Method that returns all the empty slots.
func get_empty_card_slots() -> Array[SlotClass]:
	var all_slots: Array[SlotClass] = self.get_card_slots()
	var empty_slots: Array[SlotClass] = []
	
	for slot: SlotClass in all_slots:
		if slot.card_in_slot == false:
			empty_slots.append(slot)
	
	return empty_slots

##Method that gets all the children of player slots scene and returns them as an array of SlotClass.
func get_card_slots() -> Array[SlotClass]:
	var all_slots_as_nodes: Array = get_children()
	var slots_array: Array[SlotClass] = []
	
	for slot: SlotClass in all_slots_as_nodes:
		slots_array.append(slot)
	
	return slots_array
