extends State
class_name ChoiceState

@onready var computing: ComputingState = $"../Computing"
@onready var card_pile: CardPileClass = $"../../../../CardPiles/CardPile"

var parent_enemy: EnemyClass

func enter() -> void:
	print("I am in the choice state now!")
	parent_enemy = computing.parent_enemy
	var random_number: float = randf()
	var action_cost: int 
	if random_number > 0.5:
		# Draw a card
		if parent_enemy.enemy_draw_card(card_pile):
			action_cost = 1
			parent_enemy.turn_points_remaining = parent_enemy.turn_points_remaining - action_cost
	else: 
		 # Play the first card in hand
		if parent_enemy.enemy_play_card():
			action_cost = 1
			parent_enemy.turn_points_remaining = parent_enemy.turn_points_remaining - action_cost
	Transitioned.emit(self, "idle")

func exit() -> void:
	print("I am out of the choice state!")
