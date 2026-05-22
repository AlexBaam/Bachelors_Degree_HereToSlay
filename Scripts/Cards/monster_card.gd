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
