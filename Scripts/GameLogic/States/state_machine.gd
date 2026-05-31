extends Node
class_name EnemyStateMachine

@onready var parent_enemy: EnemyClass = $".."

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

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
	return parent_enemy
