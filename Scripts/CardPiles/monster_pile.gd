extends Node2D

class_name MonsterPile

const MONSTER_SCENE_PATH = "res://Scenes/Cards/MonsterCards.tscn"
const MONSTER_DATABASE_PATH = "res://Scripts/GameData/monsters_database.gd"

const COLLISION_MASK_MONSTER_SLOT = 32

## Array that represents what monsters are in the monster pile, each defined in the "database"
var monster_pile : Array[String] = [ "Ghoul",  "Ghoul",  "Ghoul", 
									"Owlbear", "Owlbear", "Demon", 
									"Demon", "Kraken", "Kraken",
									"Elemental", "Elemental", "Dragon"]

var monster_database_reference: Resource

## This value represents the speed at which the monsters are drawn from the pile to the slot
@export var monster_draw_speed : float = 0.5

@onready var monster_manager: MonsterManager = $"../../GameLogic/MonsterManager"

@onready var monsters_left_reference: RichTextLabel = $RichTextLabel
@onready var monster_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var monster_name: RichTextLabel = $MonsterName

@onready var monster_card_slots: MonsterCardSlots = $"../../MonsterCardSlots"

# Array made out of references to every monster slot so I can check them when needed
var monster_slots: Array[MonsterSlot]

var monster_slot_1: MonsterSlot
var monster_slot_2: MonsterSlot
var monster_slot_3: MonsterSlot

# CardPileGenerals class instance
# Used for generalising redundant code
var card_pile_gen: CardPileGenerals = CardPileGenerals.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.define_monster_slots()
	
	monster_slots = [ monster_slot_1, monster_slot_2, monster_slot_3]
	
	monster_pile.shuffle() # Shuffling the deck for random cards
	monsters_left_reference.text = str(monster_pile.size())
	monster_database_reference = preload(MONSTER_DATABASE_PATH)
	fill_monster_slots(monster_slots)

func define_monster_slots() -> void:
	monster_slot_1 = monster_card_slots.get_child(0)
	monster_slot_2 = monster_card_slots.get_child(1)
	monster_slot_3 = monster_card_slots.get_child(2)

func fill_monster_slots(monster_slots_array: Array[MonsterSlot]) -> void:
	for monster_slot: MonsterSlot in monster_slots_array:
		if not monster_slot.monster_in_slot:
			draw_monster(monster_slot)
			monster_slot.monster_in_slot = true

## Method that draws a monster from the monster pile and adds it to the slot
func draw_monster(monster_slot: MonsterSlot) -> void:
	# Getting the first monster in the pile then erasing it
	var drawn_monster_name: String = monster_pile[0]
	monster_pile.erase(drawn_monster_name)
	
	# Setting the deck to invisible if there are no cards left
	if monster_pile.size() == 0:
			monster_collider.disabled = true
			card_pile_gen.pile_visibility(false,null,monsters_left_reference)
	
	monsters_left_reference.text = str(monster_pile.size())
	var monster_scene: PackedScene = preload(MONSTER_SCENE_PATH)
	var new_monster: MonsterCard = monster_scene.instantiate()
	
	# Settings the dice roll and the description of the monster
	new_monster.get_node("DiceRoll").text = str(monster_database_reference.MONSTERS[drawn_monster_name][0])
	new_monster.get_node("Description").text = str(monster_database_reference.MONSTERS[drawn_monster_name][1])
	new_monster.get_node("MonsterName").text = drawn_monster_name
	
	monster_manager.add_child(new_monster)
	
	# Adaugam pe masa un monstru, acea entitate monstru va avea acelasi nume cu ce monstru reprezinta ea
	new_monster.name = drawn_monster_name
	new_monster.position = monster_slot.position
	
	monster_slot.get_node("Area2D/CollisionShape2D").disabled = true
	
	new_monster.monster_name = drawn_monster_name
	new_monster.slot_of_the_monster = monster_slot
	
	new_monster.monster_dice_roll = int(monster_database_reference.MONSTERS[drawn_monster_name][0])
	
	var heroes_array: Array = Array(monster_database_reference.MONSTERS[drawn_monster_name][2])
	
	for hero_class: String in heroes_array:
		new_monster.slay_conditions.append(hero_class)
	
	new_monster.compute_req_heroes()
	
	monster_slot.monster_card_in_slot = new_monster
