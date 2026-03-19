extends Node2D

const MONSTER_SCENE_PATH = "res://Scenes/Monster.tscn"
const MONSTER_DATABASE_PATH = "res://Scripts/GameData/monsters_database.gd"

const COLLISION_MASK_MONSTER_SLOT = 32

var monster_pile : Array[String] = ["Owlbear", "Dragon", "Demon", "Ghoul"]
var moster_database_reference: Resource

@export var monster_draw_speed : float = 0.5

@onready var monster_manager: Node2D = $"../../MonsterManager"

@onready var monsters_left_reference: RichTextLabel = $RichTextLabel
@onready var monster_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var monster_name: RichTextLabel = $MonsterName

# References toward the monster slots
@onready var monster_slot_1: Node2D = $"../../CardSlots/MonsterCardSlots/MonsterSlot1"
@onready var monster_slot_2: Node2D = $"../../CardSlots/MonsterCardSlots/MonsterSlot2"
@onready var monster_slot_3: Node2D = $"../../CardSlots/MonsterCardSlots/MonsterSlot3"

# Array made out of references to every monster slot so I can check them when needed
@onready var monster_slots: Array[Node2D] = [ monster_slot_1, monster_slot_2, monster_slot_3]

# CardPileGenerals class instance
# Used for generalising redundant code
var card_pile_gen : CardPileGen = CardPileGen.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monster_pile.shuffle() # Shuffling the deck for random cards
	monsters_left_reference.text = str(monster_pile.size())
	moster_database_reference = preload(MONSTER_DATABASE_PATH)
	fill_monster_slots(monster_slots)

func fill_monster_slots(monster_slots_array) -> void:
	for slot in monster_slots_array:
		if not slot.monster_in_slot:
			draw_monster(slot)
			slot.monster_in_slot = true

func draw_monster(monster_slot) -> void:
	# Getting the first monster in the pile then erasing it
	var monster_drawn_name : String = monster_pile[0]
	monster_pile.erase(monster_drawn_name)
	
	# Setting the deck to invisible if there are no cards left
	if monster_pile.size() == 0:
			monster_collider.disabled = true
			card_pile_gen.pile_visibility(false,null,monsters_left_reference)
	
	monsters_left_reference.text = str(monster_pile.size())
	var monster_scene: Resource = preload(MONSTER_SCENE_PATH)
	var new_monster: Node = monster_scene.instantiate()
	
	# Settings the dice roll and the description of the monster
	new_monster.get_node("DiceRoll").text = str(moster_database_reference.MONSTERS[monster_drawn_name][0])
	new_monster.get_node("Description").text = str(moster_database_reference.MONSTERS[monster_drawn_name][1])
	new_monster.get_node("MonsterName").text = monster_drawn_name
	
	monster_manager.add_child(new_monster)
	
	# Adaugam pe masa un monstru, acea entitate monstru va avea acelasi nume cu ce monstru reprezinta ea
	new_monster.name = monster_drawn_name
	new_monster.position = monster_slot.position
