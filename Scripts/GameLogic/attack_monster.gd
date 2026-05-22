extends Node

class_name MonsterManager

const MONSTER_SLAYER: String = "monster_slayer"

## Constant to define how much we want to change the card position on the Y axis (vertical)
const SELECTED_CARD_Y_UPDATE: int = 20

@onready var player: PlayerClass = $"../../Player"

var selected_monster: MonsterCard

enum {SHOW = 1, HIDE = 2, ATTACH = 3}

func player_attack(player: PlayerClass) -> void:
	print("The player attacks an monster!")

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
