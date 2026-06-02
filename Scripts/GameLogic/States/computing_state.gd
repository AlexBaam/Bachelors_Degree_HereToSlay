extends State
class_name ComputingState

@onready var state_machine: EnemyStateMachine = $".."
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

## The entity (Player or AI) that poses the biggest threat
var highest_threat_enemy: Node 

## The numerical score of the biggest threat
var highest_threat_score: float

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

##This method selects the player from the enemies array and attributes it to the coresponding variable
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

##This method has the simple goal of iterating between all the enemies and the caller and get their scores before going to the choice state
func compute_enemies_scores() -> void:
	#Before I start computing the scores first I have to reset the trackers
	highest_threat_enemy = null
	highest_threat_score = -1.0
	
	#I start computing with the player score as it is simpler to do it
	self.player_score = calculate_threat_score(player_monsters_slayed, player_party_diversity, player_hand_size, player_empty_slots_number)
	
	#Then I do the assumption of the player being the most dancerous
	highest_threat_enemy = self.player
	highest_threat_score = self.player_score
	
	#Now we compute the enemies scores, but we do it step by step
	for enemy: EnemyClass in other_enemies:
		var current_enemy_score: float = calculate_threat_score(
			enemies_monsters_slayed[enemy], 
			enemies_party_diversity[enemy], 
			enemies_hand_size[enemy], 
			enemies_empty_slots_number[enemy]
		)
		self.enemy_score[enemy] = current_enemy_score
		
		#Simple comparation to choose the highest threat
		if current_enemy_score > highest_threat_score:
			highest_threat_score = current_enemy_score
			highest_threat_enemy = enemy
			
	#And at the end I compute this AI's score to see how close it is to winning, needed for the choice state
	self.parent_score = calculate_threat_score(parent_monsters_slayed, parent_party_diversity, parent_hand_size, parent_empty_slots_number)
	
	print("Computing done!")
	print("My score: ", self.parent_score)
	print("Myu biggest threat: ", highest_threat_enemy, " with score: ", highest_threat_score)
	
	# 4. Transition to the choice state
	Transitioned.emit(self, "choice")

## Helper function that runs the Weighted Composite math for any entity
func calculate_threat_score(monsters: int, diversity: int, hand_size: int, empty_slots: int) -> float:
	#Score given by the monsters stats
	var score_monster: float = float(monsters) / float(REQ_MONSTERS_TO_WIN)
	
	#Score given by the party diversity
	var score_party: float = 0.0
	
	#Here I check the edge case of an enemy having used all their 11 slots, but not win yet, so they have 0 chances to win with this conditon
	if empty_slots == 0 and diversity < REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN:
		score_party = 0.0 #We give him a 0 score because he cannot win this way now
	else:
		score_party = float(diversity) / float(REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN)
		
		#Now we will compute how many missing classes they have
		var missing_classes: int = REQ_NUMBER_OF_DIFFERENT_CLASSES_TO_WIN - diversity
		#And check if the missing classes are more than the hand size, and choose the lowest of the two
		#That is because if they are missing 3 classes but only have 2 cards, still cannot win
		var potential_plays: int = min(hand_size, missing_classes)
		#And increase the threat based on that information (10% more thread on an enemy with only 2 missing clases)
		score_party += float(potential_plays) * 0.05
		
	#Now we choose the maximum and minimum of the two scores to classify them
	var score_max: float = max(score_monster, score_party)
	var score_min: float = min(score_monster, score_party)
	
	#And the final threat score will be their better score of the two with an added 10% of the minimum score
	#I do this to try and go around the edge case of having two equal enemies, but can still happen
	var threat_score: float = score_max + (score_min * 0.1)
	
	#Clampf ensures the score never mathematically breaks past 1.0 (100%)
	return clampf(threat_score, 0.0, 1.0)
