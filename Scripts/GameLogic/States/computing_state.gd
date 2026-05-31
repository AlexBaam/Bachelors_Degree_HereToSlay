extends State
class_name ComputingState

@onready var state_machine: EnemyStateMachine = $".."

var parent_enemy: EnemyClass

var all_possible_enemies: Array
var player: PlayerClass

var other_enemies: Array[EnemyClass]

var player_score: float
var enemy_score: Dictionary[EnemyClass,float]

const REQ_MONSTERS_TO_WIN: int = 3
const REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN: int = 6

func enter() -> void:
	self.parent_enemy = state_machine.get_parent_of_state_machine()
	print("Got the parent enemy: " + str(self.parent_enemy))
	
	self.all_possible_enemies = parent_enemy.get_all_possible_enemies()
	print("All the possible enemies are: " + str(self.all_possible_enemies))
	
	self.define_player()
	print("Got the player: " + str(self.player))
	
	self.define_other_enemies()
	print("All the other enemies are: " + str(self.other_enemies))

func define_player() -> void:
	for rand_enemy: PlayerClass in self.all_possible_enemies:
			self.player = rand_enemy

func define_other_enemies() -> void:
	for rand_enemy: EnemyClass in self.all_possible_enemies:
		self.other_enemies.append(rand_enemy)
