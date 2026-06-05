extends State
class_name SlayState

@onready var state_machine: EnemyStateMachine = $".."
@onready var monster_manager: MonsterManager = $"../../../../GameLogic/MonsterManager"

const ACTION_COST: int = 2

func enter() -> void:
	print("Entered slay state!")
	var current_enemy: EnemyClass = state_machine.get_parent_of_state_machine()
	
	var succes: bool = await monster_manager.enemy_attack(current_enemy, state_machine.target_monster)
	
	if succes:
		state_machine.parent_enemy.turn_points_remaining = state_machine.parent_enemy.turn_points_remaining - ACTION_COST
		
	Transitioned.emit(self, "idle")

func exit() -> void:
	print("Exited the slay state!")
