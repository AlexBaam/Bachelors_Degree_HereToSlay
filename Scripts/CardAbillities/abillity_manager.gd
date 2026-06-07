extends Node

class_name AbillityManager

var battle_manager: BattleManager
var discard_pile: DiscardPileClass

var rogue: RogueClass = RogueClass.new()
var bard: BardClass = BardClass.new()
var paladin: PaladinClass = PaladinClass.new()
var fighter: FighterClass = FighterClass.new()
var wizard: WizardClass = WizardClass.new()
var ranger: RangerClass = RangerClass.new()

func setup_ability_manager(battle_man: BattleManager, disc_pile: DiscardPileClass) -> void:
	battle_manager = battle_man
	discard_pile = disc_pile
	
	add_child(rogue)
	add_child(bard)
	add_child(fighter)
	add_child(paladin)
	add_child(wizard)
	add_child(ranger)

func sanitize(card_class: String) -> String:
	card_class = card_class.to_lower()
	
	return card_class

func play_ability(card_class: String, user: Node, target: Node) -> void:
	var sanitized_class: String = self.sanitize(card_class)
	
	match sanitized_class:
		"rogue":
			rogue.use(user, target, self.battle_manager, self.discard_pile)
		"bard":
			bard.use(user, target, self.battle_manager, self.discard_pile)
		"fighter":
			fighter.use(user, target, self.battle_manager, self.discard_pile)
		"paladin":
			paladin.use(user, target, self.battle_manager, self.discard_pile)
		"wizard":
			wizard.use(user, target, self.battle_manager, self.discard_pile)
		"ranger":
			ranger.use(user, target, self.battle_manager, self.discard_pile)
