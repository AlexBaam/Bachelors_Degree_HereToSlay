extends State
class_name ComputingState

@onready var state_machine: EnemyStateMachine = $".."
@onready var card_pile: CardPileClass = $"../../../../CardPiles/CardPile"
@onready var discard_pile: DiscardPileClass = $"../../../../CardPiles/DiscardPile"

var parent_enemy: EnemyClass

var parent_enemy_action_points: int

var all_possible_enemies: Array
var player: PlayerClass

##Array that is made out of the other enemies in the game that are AI's
var other_enemies: Array[EnemyClass]

##This variable is a score that defines how close to winning is the player.
var player_score: float

var player_party_size: int
var player_party_diversity: int
var player_empty_slots_number: int
var player_monsters_slayed: int
var player_hand_size: int

##This variable is a dictionary that uses as key the enemy and as value the score taht defines how close he is to winning the game.
var enemy_score: Dictionary[EnemyClass,float]

var enemies_party_sizes: Dictionary[EnemyClass, int]
var enemies_party_diversity: Dictionary[EnemyClass, int]
var enemies_empty_slots_number: Dictionary[EnemyClass, int]
var enemies_monsters_slayed: Dictionary[EnemyClass, int]
var enemies_hand_size: Dictionary[EnemyClass, int]

var parent_score: float
var parent_party_size: int
var parent_party_diversity: int
var parent_empty_slots_number: int
var parent_monsters_slayed: int
var parent_hand_size: int

const REQ_MONSTERS_TO_WIN: int = 3
const REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN: int = 6
const MAXIMUM_NUMBER_OF_SLOTS: int = 11

func enter() -> void:
	print("Entered the computing state!")
	
	self.parent_enemy = state_machine.get_parent_of_state_machine()
	print("Got the parent enemy: " + str(self.parent_enemy))
	
	self.all_possible_enemies = parent_enemy.get_all_possible_enemies()
	print("All the possible enemies are: " + str(self.all_possible_enemies))
	
	self.define_player()
	print("Got the player: " + str(self.player))
	
	self.define_other_enemies()
	print("All the other enemies are: " + str(self.other_enemies))
	
	self.parent_enemy_action_points = self.parent_enemy.get_action_points()
	
	# Here we get the size of each enemy hand
	self.define_hand_sizes()
	
	# Here we get the party size of each enemy, how diverse they are and how many left empty slots they have
	self.define_party_sizes()
	
	# Here we get the number of monsters slayed by each enemy
	self.define_monsters_slayed()
	
	# Here we compute each enemy score
	self.compute_enemies_scores()

func exit() -> void:
	print("Exited the computing state!")

func define_player() -> void:
	for rand_enemy in self.all_possible_enemies:
		if rand_enemy is PlayerClass:
			self.player = rand_enemy

func define_other_enemies() -> void:
	for rand_enemy in self.all_possible_enemies:
		if rand_enemy is EnemyClass:
			self.other_enemies.append(rand_enemy)

##Method that returns nothing and only defines how big the enemy parties are, how diverse they are and how many empty slots they have left.
func define_party_sizes() -> void:
	self.player_party_size = player.get_party_size()
	self.player_party_diversity = player.get_diverse_party_size()
	self.player_empty_slots_number = MAXIMUM_NUMBER_OF_SLOTS - self.player_party_size
	
	for enemy: EnemyClass in other_enemies:
		self.enemies_party_sizes[enemy] = enemy.get_party_size()
		self.enemies_party_diversity[enemy] = enemy.get_diverse_party_size()
		self.enemies_empty_slots_number[enemy] = MAXIMUM_NUMBER_OF_SLOTS - self.enemies_party_sizes[enemy]
	
	self.parent_party_size = parent_enemy.get_party_size()
	self.parent_party_diversity = parent_enemy.get_diverse_party_size()
	self.parent_empty_slots_number = MAXIMUM_NUMBER_OF_SLOTS - self.parent_party_size

##Method that defines how many monsters each enemy has slayed, at a maximum of three when it's clear that the enemy won.
func define_monsters_slayed() -> void:
	self.player_monsters_slayed = player.get_slayed_monsters_number()
	
	for enemy: EnemyClass in other_enemies:
		self.enemies_monsters_slayed[enemy] = enemy.get_slayed_monsters_number()
	
	self.parent_monsters_slayed = parent_enemy.get_slayed_monsters_number()

func define_hand_sizes() -> void:
	self.player_hand_size = player.get_hand_size()
	
	for enemy: EnemyClass in other_enemies:
		self.enemies_hand_size[enemy] = enemy.get_hand_size()
	
	self.parent_hand_size = parent_enemy.get_hand_size()

func compute_enemies_scores() -> void:
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
