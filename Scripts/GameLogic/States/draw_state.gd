extends State
class_name DrawState

@onready var state_machine: EnemyStateMachine = $".."
@onready var card_pile: CardPileClass = $"../../../../CardPiles/CardPile"

const ACTION_COST: int = 1

func enter() -> void:
	print("Entered draw state!")
	if state_machine.parent_enemy.enemy_draw_card(card_pile):
		state_machine.parent_enemy.turn_points_remaining = state_machine.parent_enemy.turn_points_remaining - ACTION_COST
	
	Transitioned.emit(self, "idle")

func exit() -> void:
	print("Exited the draw state!")
