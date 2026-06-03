extends Node

class_name AbillityManager

var rogue: RogueClass = RogueClass.new()
var bard: BardClass = BardClass.new()
var paladin: PaladinClass = PaladinClass.new()
var fighter: FighterClass = FighterClass.new()
var wizard: WizardClass = WizardClass.new()
var ranger: RangerClass = RangerClass.new()

func enemy_play_abillity(card_class: String, target: Node) -> void:
	var sanitized_class: String = self.sanitize(card_class)
	
	match sanitized_class:
		"rogue":
			add_child(rogue)
			rogue.enemy_use(target)
		"bard":
			add_child(bard)
			bard.enemy_use(target)
		"fighter":
			add_child(fighter)
			fighter.enemy_use(target)
		"paladin":
			add_child(paladin)
			paladin.enemy_use(target)
		"wizard":
			add_child(wizard)
			wizard.enemy_use(target)
		"ranger":
			add_child(ranger)
			ranger.enemy_use(target)

func play_abillity(card_class: String) -> void:
	var sanitized_class: String = self.sanitize(card_class)
	
	match sanitized_class:
		"rogue":
			add_child(rogue)
			rogue.use()
		"bard":
			add_child(bard)
			bard.use()
		"fighter":
			add_child(fighter)
			fighter.use()
		"paladin":
			add_child(paladin)
			paladin.use()
		"wizard":
			add_child(wizard)
			wizard.use()
		"ranger":
			add_child(ranger)
			ranger.use()

func sanitize(card_class: String) -> String:
	card_class = card_class.to_lower()
	
	return card_class
