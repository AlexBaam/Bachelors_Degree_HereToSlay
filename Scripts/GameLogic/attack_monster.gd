extends Node

class_name MonsterManager

const MONSTER_SLAYER: String = "monster_slayer"
const ACTION_POINTS: String = "action_points"

## Constant to define how much we want to change the card position on the Y axis (vertical)
const SELECTED_CARD_Y_UPDATE: int = 20

const ACTION_COST: int = 2

@onready var player: PlayerClass = $"../../Player"

var selected_monster: MonsterCard

enum {SHOW = 1, HIDE = 2, ATTACH = 3}

func player_attack(player_received: PlayerClass, monster: MonsterCard) -> void:
	var action_points: ActionPoints = player.get_child_via_name(ACTION_POINTS)
	
	if action_points.check_action_possibility(ACTION_COST):
		if player_received.get_party_size() >= monster.heroes_required_to_attack:
			if self.check_slay_conditions(monster, player_received):
				print("To be implemented further!")
			else:
				print("Cannot attack this monster! Conditions to attack not met!")
		else:
			print("Cannot attack this monster! Not enough party members!")
	else:
		print("Cannot attack monsters! Not enough action points!")

func enemy_attack(enemy: EnemyClass) -> void:
	print("The " + str(enemy) + " wants to attack a monster!")

func check_slay_conditions(monster: MonsterCard, player_received: PlayerClass) -> bool:
	var slay_conditions: Array[String] = monster.slay_conditions
	var party: Array[CardClass] = player_received.cards_in_slots
	
	var party_classes: Array[String]
	
	var matching_cases: int = 0
	
	for card: CardClass in party:
		if card.card_class not in party_classes:
			party_classes.append(card.card_class)
	
	print(party_classes)
	print(slay_conditions)
	
	for hero_class_req: String in slay_conditions:
		if hero_class_req == "Any":
			matching_cases = matching_cases + 1
		else:
			for hero_class: String in party_classes:
				if hero_class_req == hero_class:
					matching_cases = matching_cases + 1
	
	if matching_cases >= monster.heroes_required_to_attack:
		return true
	else:
		return false

func select_monster(monster: MonsterCard) -> void:
	if selected_monster:
		if self.is_this_monster_already_selected(monster):
			self.unselect_monster()
		else:
			self.change_selected_monster(monster)
	else:
		selected_monster = monster
		selected_monster.position.y -= SELECTED_CARD_Y_UPDATE
		player.call_child(MONSTER_SLAYER, [ATTACH, selected_monster])

func is_this_monster_already_selected(monster: MonsterCard) -> bool:
	if selected_monster == monster:
		return true
	else: 
		return false

func unselect_monster() -> void:
	if selected_monster:
		selected_monster.position.y += SELECTED_CARD_Y_UPDATE
		player.call_child(MONSTER_SLAYER, [HIDE])
		selected_monster = null

func change_selected_monster(monster: MonsterCard) -> void:
	selected_monster.position.y += SELECTED_CARD_Y_UPDATE
	selected_monster = monster
	selected_monster.position.y -= SELECTED_CARD_Y_UPDATE
	player.call_child(MONSTER_SLAYER, [ATTACH, selected_monster])
