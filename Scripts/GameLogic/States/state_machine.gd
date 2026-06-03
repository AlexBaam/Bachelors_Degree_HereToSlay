extends Node
class_name EnemyStateMachine

@onready var parent_enemy: EnemyClass = $".."

#State machien specific variables

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

# Shared variables between states

var all_possible_enemies: Array
var player: PlayerClass
##Array that is made out of the other enemies in the game that are AI's
var other_enemies: Array[EnemyClass]

##The entity (Player or AI) that poses the biggest threat
var most_dangerous_enemy: Node
##The numerical score of the biggest threat
var most_dangerous_enemy_score: float
##The numerical score of the enemy that is computing right now
var parent_score: float

##This variable will store the name of state in which we will go after choice state (slay, attack, draw)
var target_action: String = ""

##This variable will store the name of the monster that we chose for slay action
var target_monster_name: String = ""

##This variable will store the chosen enemy to attack in the attack state
var target_enemy_node: Node = null

##This variable will store the chosen card to play in attack state
var target_card_to_play: CardClass

const REQ_MONSTERS_TO_WIN: int = 3
const REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN: int = 6
const MAXIMUM_NUMBER_OF_SLOTS: int = 11

func _ready() -> void:
	for state: State in get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.Transitioned.connect(on_state_transition)
		
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_state_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
	
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state

func get_parent_of_state_machine() -> EnemyClass:
	return self.parent_enemy

##This method selects the player from the enemies array and attributes it to the coresponding variable
func define_player() -> void:
	for rand_enemy: Node in self.all_possible_enemies:
		if rand_enemy is PlayerClass:
			self.player = rand_enemy

func get_player_from_state_machine() -> PlayerClass:
	return self.player

func define_other_enemies() -> void:
	self.other_enemies.clear()
	for rand_enemy: Node in self.all_possible_enemies:
		if rand_enemy is EnemyClass:
			self.other_enemies.append(rand_enemy)

func get_other_enemies_from_state_machine() -> Array[EnemyClass]:
	return self.other_enemies

func define_components() -> void:
	self.all_possible_enemies = parent_enemy.get_all_possible_enemies()
	
	self.define_player()
	
	self.define_other_enemies()
