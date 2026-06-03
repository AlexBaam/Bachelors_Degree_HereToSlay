extends State
class_name SlayState

@onready var state_machine: EnemyStateMachine = $".."

const ACTION_COST: int = 2

func enter() -> void:
	print("Entered slay state!")
	state_machine.parent_enemy.turn_points_remaining = state_machine.parent_enemy.turn_points_remaining - ACTION_COST
	
	Transitioned.emit(self, "idle")

func exit() -> void:
	print("Exited the slay state!")
