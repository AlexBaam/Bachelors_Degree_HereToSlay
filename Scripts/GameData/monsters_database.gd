const MONSTERS : Dictionary[String, Array] = { # Name, Dice roll to slay, Description, Classes needed to attack
	"Ghoul" : ["4", "Two of any type of hero!", ["Any", "Any"]],
	"Owlbear" : ["5", "Two of any type of hero!", ["Any", "Any"]],
	"Elemental" : ["6", "A paladin and a wizard!", ["Paladin", "Wizard"]],
	"Kraken" : ["7", "Rogue, ranger and a fighter!", ["Rogue", "Ranger", "Fighter" ]],
	"Demon" : ["8", "Bard, rogue and a fighter!", ["Bard", "Rogue", "Fighter"]],
	"Dragon" : ["9", "Paladin, bard, ranger and a wizard!", ["Paladin", "Bard", "Ranger", "Wizard"]],
}
