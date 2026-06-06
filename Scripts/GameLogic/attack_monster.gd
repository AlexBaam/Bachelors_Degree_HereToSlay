extends Node

class_name MonsterManager

const MONSTER_SLAYER: String = "monster_slayer"
const ACTION_POINTS: String = "action_points"

## Constant to define how much we want to change the card position on the Y axis (vertical)
const SELECTED_CARD_Y_UPDATE: int = 20

const ACTION_COST: int = 2

@onready var player: PlayerClass = $"../../Player"
@onready var monster_pile: MonsterPile = $"../../CardPiles/MonsterPile"

var selected_monster: MonsterCard

func player_attack(player_received: PlayerClass, monster: MonsterCard) -> void:
	var action_points: ActionPoints = player.get_action_points()
	
	if action_points.check_action_possibility(ACTION_COST):
		var party: Array[CardClass] = player_received.cards_in_slots
		if monster.check_slay_conditions(party):
			var dice: DiceClass = player.get_dice()
			var result: int = await dice.roll_dice()
				
			if result >= monster.monster_dice_roll:
				print("Dice roll result is: " + str(result))
				print("Monster slayed yipeee!!!!")
					
				player_received.increase_slayed_monsters()
				self.remove_monster_from_game(monster)
					
			else:
				print("Aw dang it!")
				
			player_received.update_player_action_points(ACTION_COST)
		else:
			print("Cannot attack this monster! Conditions to attack not met!")
	else:
		print("Cannot attack monsters! Not enough action points!")

func enemy_attack(enemy: EnemyClass, monster: MonsterCard) -> bool:
	print("The " + str(enemy) + " wants to attack a monster!")
	var party: Array[CardClass] = enemy.get_enemy_party()
	if monster.check_slay_conditions(party):
		var dice: DiceClass = player.get_dice()
		var result: int = await dice.roll_dice()
			
		if result >= monster.monster_dice_roll:
			print("Dice roll result is: " + str(result))
			print("Monster slayed yipeee!!!!")
				
			enemy.increase_slayed_monsters()
			self.remove_monster_from_game(monster)
			
			return true
		else:
			print("Aw dang it!")
			return true
	else:
		print("Cannot attack this monster! Conditions to attack not met!")
		return false

func remove_monster_from_game(monster: MonsterCard) -> void:
	var monster_slot: MonsterSlot = monster.get_monster_slot()
	monster_slot.monster_in_slot = false
	
	monster.queue_free()
	
	monster_pile.draw_monster(monster_slot)

func select_monster(monster: MonsterCard) -> void:
	if selected_monster:
		if self.is_this_monster_already_selected(monster):
			self.unselect_monster()
		else:
			self.change_selected_monster(monster)
	else:
		selected_monster = monster
		selected_monster.position.y -= SELECTED_CARD_Y_UPDATE
		player.attach_to_monster_card(selected_monster)

func is_this_monster_already_selected(monster: MonsterCard) -> bool:
	if selected_monster == monster:
		return true
	else: 
		return false

func unselect_monster() -> void:
	if selected_monster:
		selected_monster.position.y += SELECTED_CARD_Y_UPDATE
		player.hide_attack_monster_button()
		selected_monster = null

func change_selected_monster(monster: MonsterCard) -> void:
	selected_monster.position.y += SELECTED_CARD_Y_UPDATE
	selected_monster = monster
	selected_monster.position.y -= SELECTED_CARD_Y_UPDATE
	player.attach_to_monster_card(selected_monster)
