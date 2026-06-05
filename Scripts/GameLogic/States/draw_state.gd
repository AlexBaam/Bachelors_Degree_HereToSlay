extends State
class_name DrawState

@onready var state_machine: EnemyStateMachine = $".."
@onready var card_pile: CardPileClass = $"../../../../CardPiles/CardPile"
@onready var battle_timer: Timer = $"../../../../GameLogic/BattleTimer"

const ACTION_COST: int = 1

func enter() -> void:
	print("Entered draw state!")
	battle_timer.wait_time = 0.5
	battle_timer.start()
	await battle_timer.timeout
	
	var success: bool  = state_machine.parent_enemy.enemy_draw_card(card_pile)
	
	battle_timer.wait_time = 0.5
	battle_timer.start()
	await battle_timer.timeout
	
	if success:
		state_machine.parent_enemy.turn_points_remaining = state_machine.parent_enemy.turn_points_remaining - ACTION_COST
		
	Transitioned.emit(self, "idle")

func exit() -> void:
	print("Exited the draw state!")
