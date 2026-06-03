extends State
class_name ChoiceState

@onready var state_machine: EnemyStateMachine = $".."
@onready var card_pile: CardPileClass = $"../../../../CardPiles/CardPile"
@onready var discard_pile: DiscardPileClass = $"../../../../CardPiles/DiscardPile"
@onready var computing: ComputingState = $"../Computing"
@onready var monster_card_slots: MonsterCardSlots = $"../../../../MonsterCardSlots"

var parent_enemy: EnemyClass

#Constants that represent the states
const IDLE_STATE: String = "idle"
const ATTACK_STATE: String = "attack"
const SLAY_STATE: String = "slay"
const DRAW_STATE: String = "draw"

#How much a specific win condition is worth mathematically
const WIN_CONDITION_VALUE: float = 1000.0 
const MONSTER_VALUE: float = 0.33
const DIVERSITY_VALUE: float = 0.16
const HAND_POTENTIAL_VALUE: float = 0.05

func enter() -> void:
	print("Now in choice state!")
	self.parent_enemy = state_machine.get_parent_of_state_machine()
	
	var current_action_points: int = parent_enemy.get_action_points()
	print("Current number of action points: ", current_action_points)
	
	#The first edge case to be considered is the out of action points.
	if current_action_points == 0:
		print("Out of action points, turn's over for: " + str(self.name))
		state_machine.target_action = IDLE_STATE
		Transitioned.emit(self, state_machine.target_action)
		return
		
	var my_score: float = state_machine.parent_score
	var enemy_score: float = state_machine.most_dangerous_enemy_score
	var dangerous_enemy: Node = state_machine.most_dangerous_enemy
	
	#These are some numbers we will use for multiplying the scores to keep track of how urgent a move is
	var self_urgency: float = 1.0
	var enemy_urgency: float = 1.0
	
	#If my score is above a threshold it's better to go directly for the win than sabotage the enemy
	if my_score >= 0.66:
		self_urgency = 2.0
	if enemy_score >= 0.8: #This score so high means the enemy is really close to winning
		enemy_urgency = 3.0

	#Using best action we will track the most valuable action that can be realized
	var best_action: String = DRAW_STATE #Fallback in case things get stuck along the way
	var highest_expected_value_per_ap: float = -1.0 #Here we setup the highest expected value we can get from an action PER ACTION POINT so we can do comparasions later
	
	#Temporary variables to save in the state machine later for the action state we will choose
	var chosen_monster: MonsterCard = null
	var chosen_card: CardClass = null
	var chosen_card_is_from: String = ""
	var chosen_target_enemy: Node = dangerous_enemy
	
	# Now we check if we can actually draw a card as a fallback
	if card_pile.get_card_pile_size() > 0: 
		var draw_expected_value: float = 0.05 * self_urgency # Base value of drawing a card
		
		if computing.parent_empty_slots_number == 0:
			#If we don't have empty slots we shouldn't draw cards, as it is useless because we already have other 11 to use
			draw_expected_value = 0.0
		elif computing.parent_hand_size == 0:
			#But if I still have slots and no cards, I should draw because it might win me the game with the card we get
			draw_expected_value += 0.10
			
		highest_expected_value_per_ap = draw_expected_value
		
	#Now I should check the case where I have 2 or more action points and I can still attack a monster
	if current_action_points >= 2:
		var slay_data: Dictionary = evaluate_monsters(self_urgency)
		#This is the expected value PER action point of each, that why I divide here
		var slay_expected_value_per_ap: float = slay_data["ev"] / 2.0
		
		if slay_expected_value_per_ap > highest_expected_value_per_ap:
			highest_expected_value_per_ap = slay_expected_value_per_ap
			best_action = SLAY_STATE
			chosen_monster = slay_data["monster"]
			
	#Next step is to see if there is any valuable card move I can do
	if current_action_points >= 1:
		var attack_data: Dictionary = evaluate_cards(self_urgency, enemy_urgency, dangerous_enemy)
		var attack_expected_value: float = attack_data["ev"]
		
		if attack_expected_value > highest_expected_value_per_ap:
			highest_expected_value_per_ap = attack_expected_value
			best_action = ATTACK_STATE
			chosen_card = attack_data["card"]
			chosen_card_is_from = attack_data["where_from"]
			chosen_target_enemy = dangerous_enemy
	
	#Update the state machine data
	print("Best action computed: ", best_action, " and its expected_value/action_point: ", highest_expected_value_per_ap)
	
	state_machine.target_action = best_action
	state_machine.target_monster = chosen_monster
	state_machine.target_card_to_play = chosen_card
	state_machine.target_card_is_from = chosen_card_is_from
	state_machine.target_enemy_node = chosen_target_enemy
	
	Transitioned.emit(self, best_action)

func exit() -> void:
	print("Exiting choice state!")

##This method takes the monsters in the slots and evaluates which is the best to attack, so we get an expected value to compare to other actions
func evaluate_monsters(self_urgency: float) -> Dictionary:
	var party: Array[CardClass] = parent_enemy.cards_played_by_opponent
	
	var best_monster_to_attack_expected_value: float = 0.0
	var best_monster_to_attack: MonsterCard = null
	
	var table_monsters: Array[MonsterCard] = monster_card_slots.get_monster_cards_in_slots()
	
	for monster: MonsterCard in table_monsters:
		#First we check if we can attack the monster, otherwise is useleess to compute for this monster
		var can_attack: bool = monster.check_slay_conditions(party)
		if can_attack:
			var success_chance: float = compute_2d6_probability(monster.monster_dice_roll)
			var utility: float = MONSTER_VALUE * self_urgency
			
			#Now we check if this is the last monster needed to win
			if computing.parent_monsters_slayed == 2:
				utility = WIN_CONDITION_VALUE
				
			var current_ev: float = success_chance * utility
			if current_ev > best_monster_to_attack_expected_value:
				best_monster_to_attack_expected_value = current_ev
				best_monster_to_attack = monster
				
	return {"ev": best_monster_to_attack_expected_value, "monster": best_monster_to_attack}

func evaluate_cards(self_urgency: float, enemy_urgency: float, target_enemy: Node) -> Dictionary:
	var best_card_expected_value: float = 0.0
	var best_card: CardClass = null
	var card_is_from: String = ""
	
	var available_cards: Array[CardClass] = parent_enemy.get_cards_in_hand()
	for card: CardClass in parent_enemy.cards_played_by_opponent:
		available_cards.append(card)
	
	var cards_in_hand: Array[CardClass] = parent_enemy.get_cards_in_hand()
	
	var can_play_new_cards: bool = (computing.parent_empty_slots_number > 0)
	var target_party_size: int = self.get_target_party_size(target_enemy)
	var target_hand_size: int = self.get_target_hand_size(target_enemy)
	
	for card: CardClass in available_cards:
		#Here we ignore the cards already played this turn
		if card.card_played_this_turn:
			continue
			
		var is_in_hand: bool = false
		if card in cards_in_hand:
			is_in_hand = true
		
		#Here we check if the card is in the hand, and we have no empty slots, so we skip the card
		if is_in_hand and not can_play_new_cards:
			continue
		
		var utility: float = 0.0
		if is_in_hand:
			utility += (DIVERSITY_VALUE * self_urgency)
			
		var success_chance: float = compute_2d6_probability(card.card_dice_roll)
		var ability_utility: float = 0.0
		
		# Identify the class ability and calculate specific utility
		match card.card_class:
			"Fighter":
				if target_party_size > 0:
					ability_utility = (DIVERSITY_VALUE * 2.0) * enemy_urgency
			"Paladin":
				if target_party_size > 0:
					ability_utility = (DIVERSITY_VALUE * enemy_urgency) + (DIVERSITY_VALUE * self_urgency)
			"Rogue":
				if target_hand_size > 0:
					ability_utility = (HAND_POTENTIAL_VALUE * enemy_urgency) + (HAND_POTENTIAL_VALUE * self_urgency)
			"Ranger":
				if target_hand_size > 0:
					ability_utility = (HAND_POTENTIAL_VALUE * enemy_urgency)
			"Bard":
				if discard_pile.get_discard_pile_size() > 0:
					ability_utility = DIVERSITY_VALUE * self_urgency
			"Wizard":
				ability_utility = ((DIVERSITY_VALUE * 2.0) + (DIVERSITY_VALUE * 2.0) + (HAND_POTENTIAL_VALUE * 2.0) + HAND_POTENTIAL_VALUE + DIVERSITY_VALUE) / 5.0
				ability_utility *= max(self_urgency, enemy_urgency) 
				
		var total_ev: float = (success_chance * ability_utility) + utility
		
		if total_ev > best_card_expected_value:
			best_card_expected_value = total_ev
			best_card = card
		
	if best_card != null and best_card in cards_in_hand:
		card_is_from = "hand"
	else:
		card_is_from ="party"
	
	return {"ev": best_card_expected_value, "card": best_card, "where_from": card_is_from}

##Helper to convert 2d6 target roll to a percentage (0.0 to 1.0).
##To be noted, this computes the chance to get a roll higher or equal to the dice, not exactly it.
func compute_2d6_probability(target_roll: int) -> float:
	match target_roll:
		2: return 1.0
		3: return 0.972
		4: return 0.916
		5: return 0.833
		6: return 0.722
		7: return 0.583
		8: return 0.416
		9: return 0.277
		10: return 0.166
		11: return 0.083
		12: return 0.027
		_: return 0.0

##This is a helper function to sort out if the most dangerous enemy is the player (PlayerClass) or AI (EnemyClass) and get it's party size
func get_target_party_size(target: Node) -> int:
	if target is PlayerClass:
		return computing.player_party_size
	elif target is EnemyClass:
		var enemy_target: EnemyClass = target
		return computing.enemies_party_sizes[enemy_target]
	return 0

##This is a helper function to sort out if the most dangerous enemy is the player (PlayerClass) or AI (EnemyClass) and get it's hand size
func get_target_hand_size(target: Node) -> int:
	if target is PlayerClass:
		return computing.player_hand_size
	elif target is EnemyClass:
		var enemy_target: EnemyClass = target
		return computing.enemies_hand_size[enemy_target]
	return 0
