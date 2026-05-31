extends State
class_name ComputingState

@onready var state_machine: EnemyStateMachine = $".."

var parent_enemy: EnemyClass

var parent_enemy_action_points: int

var all_possible_enemies: Array
var player: PlayerClass

var other_enemies: Array[EnemyClass]

var player_score: float
var player_party_size: int
var player_party_diversity: int
var player_empty_slots_number: int
var player_monsters_slayed: int

var enemy_score: Dictionary[EnemyClass,float]
var enemies_party_sizes: Dictionary[EnemyClass, int]
var enemies_party_diversity: Dictionary[EnemyClass, int]
var enemies_empty_slots_number: Dictionary[EnemyClass, int]
var enemies_monsters_slayed: Dictionary[EnemyClass, int]

const REQ_MONSTERS_TO_WIN: int = 3
const REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN: int = 6
const MAXIMUM_NUMBER_OF_SLOTS: int = 11

func enter() -> void:
	self.parent_enemy = state_machine.get_parent_of_state_machine()
	print("Got the parent enemy: " + str(self.parent_enemy))
	
	self.all_possible_enemies = parent_enemy.get_all_possible_enemies()
	print("All the possible enemies are: " + str(self.all_possible_enemies))
	
	self.define_player()
	print("Got the player: " + str(self.player))
	
	self.define_other_enemies()
	print("All the other enemies are: " + str(self.other_enemies))
	
	self.parent_enemy_action_points = self.parent_enemy.get_action_points()
	
	self.define_party_sizes()
	self.define_monsters_slayed()

func define_player() -> void:
	for rand_enemy: PlayerClass in self.all_possible_enemies:
			self.player = rand_enemy

func define_other_enemies() -> void:
	for rand_enemy: EnemyClass in self.all_possible_enemies:
		self.other_enemies.append(rand_enemy)

func define_party_sizes() -> void:
	self.player_party_size = player.get_party_size()
	self.player_party_diversity = player.get_diverse_party_size()
	self.player_empty_slots_number = MAXIMUM_NUMBER_OF_SLOTS - self.player_party_size
	
	for enemy: EnemyClass in other_enemies:
		self.enemies_party_sizes[enemy] = enemy.get_party_size()
		self.enemies_party_diversity[enemy] = enemy.get_diverse_party_size()
		self.enemies_empty_slots_number[enemy] = MAXIMUM_NUMBER_OF_SLOTS - self.enemies_party_sizes[enemy]

func define_monsters_slayed() -> void:
	self.player_monsters_slayed = player.get_slayed_monsters_number()
	
	for enemy: EnemyClass in other_enemies:
		self.enemies_monsters_slayed[enemy] = enemy.get_slayed_monsters_number()
