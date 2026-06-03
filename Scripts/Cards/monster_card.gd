extends Node2D

class_name MonsterCard

## This value is the name of the card
var monster_name: String 

## This variable defines the dice result needed to defeat the monster
var monster_dice_roll: int

## This array represents the classes needed in a party to attack the monster
var slay_conditions: Array[String]

## This variable defines how many members are needed in the party to attack this monster
var heroes_required_to_attack: int 

var slot_of_the_monster: MonsterSlot

func compute_req_heroes() -> void:
	self.heroes_required_to_attack = slay_conditions.size()

func get_monster_slot() -> MonsterSlot:
	return self.slot_of_the_monster

func check_slay_conditions(party: Array[CardClass]) -> bool:
	if party.size() < self.heroes_required_to_attack:
		print("You cannot attack this monster! Not enough party members!")
		return false
	
	var party_classes: Array[String]
	var matching_cases: int = 0
	
	for card: CardClass in party:
		if card.card_class not in party_classes:
			party_classes.append(card.card_class)
	
	print(party_classes)
	print(self.slay_conditions)
	
	for hero_class_req: String in self.slay_conditions:
		if hero_class_req == "Any":
			matching_cases = matching_cases + 1
		else:
			for hero_class: String in party_classes:
				if hero_class_req == hero_class:
					matching_cases = matching_cases + 1
	
	if matching_cases >= self.heroes_required_to_attack:
		return true
	else:
		return false
