extends Node

class_name AbillityManager

var rogue: RogueClass = RogueClass.new()
var bard: BardClass = BardClass.new()
var paladin: PaladinClass = PaladinClass.new()
var fighter: FighterClass = FighterClass.new()
var wizard: WizardClass = WizardClass.new()
var ranger: RangerClass = RangerClass.new()

func _ready() -> void:
	add_child(rogue)
	add_child(bard)
	add_child(fighter)
	add_child(paladin)
	add_child(wizard)
	add_child(ranger)

func enemy_play_abillity(card_class: String, target: Node) -> void:
	var sanitized_class: String = self.sanitize(card_class)
	
	match sanitized_class:
		"rogue":
			rogue.enemy_use(target)
		"bard":
			bard.enemy_use(target)
		"fighter":
			fighter.enemy_use(target)
		"paladin":
			paladin.enemy_use(target)
		"wizard":
			wizard.enemy_use(target)
		"ranger":
			ranger.enemy_use(target)

func play_abillity(card_class: String) -> void:
	var sanitized_class: String = self.sanitize(card_class)
	
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
