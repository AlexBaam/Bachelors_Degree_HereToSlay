extends State
class_name AttackState

@onready var state_machine: EnemyStateMachine = $".."
@onready var enemy_card_player: EnemyCardPlayer = $"../../EnemyCardPlayer"

const ACTION_COST: int = 1

func enter() -> void:
	print("Entered attack state!")
	if state_machine.parent_enemy.enemy_play_card(state_machine.target_card_to_play, state_machine.target_card_is_from, state_machine.target_enemy_node):
		state_machine.parent_enemy.turn_points_remaining = state_machine.parent_enemy.turn_points_remaining - ACTION_COST
	
	Transitioned.emit(self, "idle")

func exit() -> void:
	print("Exited the attack state!")
