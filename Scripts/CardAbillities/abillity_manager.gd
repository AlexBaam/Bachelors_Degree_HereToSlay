extends Node

class_name AbillityManager

var rogue: RogueClass = RogueClass.new()
var bard: BardClass = BardClass.new()
var paladin: PaladinClass = PaladinClass.new()
var fighter: FighterClass = FighterClass.new()
var wizard: WizardClass = WizardClass.new()
var ranger: RangerClass = RangerClass.new()

func play_abillity(card_class: String) -> void:
	var sanitized_class: String = sanitize(card_class)
	
	match sanitized_class:
		"rogue":
			rogue.use()
		"bard":
			bard.use()
		"fighter":
			fighter.use()
		"paladin":
			paladin.use()
		"wizard":
			wizard.use()
		"ranger":
			ranger.use()

func sanitize(card_class: String) -> String:
	card_class = card_class.to_lower()
	
	return card_class
