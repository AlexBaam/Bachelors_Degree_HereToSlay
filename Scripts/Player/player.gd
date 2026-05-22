extends Node

class_name PlayerClass

# All the constants here are names that define each child of the player scene so I can call them just using the player
const ACTION_POINTS: String = "action_points"
const PLAYER_HAND: String =  "player_hand"
const CARD_PLAY_BUTTON: String = "play_button"
const PLAYER_CARD_SLOTS: String = "player_card_slots"
const DISCARD_HAND_BUTTON: String = "discard_hand"
const MONSTER_SLAYER: String = "monster_slayer"
const DICE: String = "dice"

var player_slots: PlayerCardSlotsClass
var player_hand: PlayerHand
var action_points: ActionPoints
var card_play: CardPlayer
var discard_hand: DiscardHandClass
var monster_slayer: MonsterSlayer
var dice: DiceClass

## This array represents the party
var cards_in_slots: Array[CardClass] = []

##This variable counts how many monsters the player slayed this match
var monsters_slayed: int 

func _ready() -> void:
	define_player_components()
	
	monsters_slayed = 0

## This function sets each component of the player to it's variable
func define_player_components() -> void:
	var player_components: Array = get_children()
	
	print("The list of player components is: ", player_components)
	
	player_slots = player_components[0]
	player_hand = player_components[1]
	action_points = player_components[2]
	card_play = player_components[3]
	discard_hand = player_components[4]
	monster_slayer = player_components[5]
	dice = player_components[6]

## This function allows the parent to call a child based on it's string name
## THe first parameter is the child name, and the second is an actions array that defines what do we want that child to do
func call_child(child_name: String, action: Array) -> void:
	var child: Node2D = get_child_via_name(child_name)
	child.do(action)

## This function returns a child component of the player scene based on a predefined string.
## The allowed strings are:[br]
## Player's action points: "action_points"[br]
## The card hand of the player: "player_hand"[br]
## Play card button: "play_button"[br]
## Card slots of the player: "player_card_slots"[br]
## Discard hand button: "discard_hand"[br]
## Attack monster button: "monster_slayer"[br]
## Dice: "dice"[br]
func get_child_via_name(child_name: String) -> Node2D:
	if child_name == ACTION_POINTS:
		return action_points
	elif child_name == PLAYER_HAND:
		return player_hand
	elif child_name == CARD_PLAY_BUTTON:
		return card_play
	elif child_name == PLAYER_CARD_SLOTS:
		return player_slots
	elif child_name == DISCARD_HAND_BUTTON:
		return discard_hand
	elif child_name == MONSTER_SLAYER:
		return monster_slayer
	elif child_name == DICE:
		return dice
	
	return null

## This function returns how many action points the player has at that respective moment
func get_action_points_left() -> int:
	return action_points.get_action_points_left()

## This function resets the card played status of the cards in the party after the turn ends
func reset_played_cards_status() -> void: 
	for card: CardClass in cards_in_slots:
		card.card_played_this_turn = false

## This function adds a card to the player party. A party is formed of the cards in the slots that can be played every turn
func add_card_to_player_party(card_played: CardClass) -> void:
	cards_in_slots.append(card_played)
	print(cards_in_slots)

## This method returns the size of the player party
func get_party_size() -> int:
	return cards_in_slots.size()

## This method returns the dice scene for rolling
func get_dice() -> DiceClass:
	return self.dice

## This method increases the number of monsters slayed by one
func increase_slayed_monsters() -> void:
	self.monsters_slayed = self.monsters_slayed + 1
	print("Monsters slayed so far: ", self.monsters_slayed)
