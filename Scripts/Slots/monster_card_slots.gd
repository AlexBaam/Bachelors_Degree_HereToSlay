extends Node2D
class_name MonsterCardSlots

func get_monster_cards_in_slots() -> Array[MonsterCard]:
	var monster_array: Array[MonsterCard] = []
	for monster_slot: MonsterSlot in self.get_children():
		var monster_card: MonsterCard = monster_slot.monster_card_in_slot
		monster_array.append(monster_card)
	
	return monster_array
