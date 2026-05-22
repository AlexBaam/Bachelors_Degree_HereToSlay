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

func player_attack(player: PlayerClass, monster: MonsterCard) -> void:
	var action_points: ActionPoints = player.get_child_via_name(ACTION_POINTS)
	
	if action_points.check_action_possibility(ACTION_COST):
		if player.get_party_size() >= monster.heroes_required_to_attack:
			pass
		else:
			print("Cannot attack this monster! Conditions to attack not met!")
	else:
		print("Cannot attack monsters! Not enough action points!")

func enemy_attack(enemy: EnemyClass) -> void:
	pass

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
