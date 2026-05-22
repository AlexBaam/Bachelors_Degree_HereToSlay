extends Node2D

class_name MonsterSlayer

## This value represents how much I have to substract from the position of the button attached to the center of the card to be above it
const BUTTON_ATTACH_Y_UPDATE: int = 110

## This value represents how much I have to substract from the position of the button attached to the center of the card to centered with it
const BUTTON_ATTACH_X_UPDATE: int = 26

@onready var attack_monster_button: Button = $AttackMonsterButton
@onready var dice: Node2D = $Dice
@onready var player: PlayerClass = $".."
@onready var monster_manager: MonsterManager = $"../../GameLogic/MonsterManager"

@onready var card_piles: Node2D = $"../../CardPiles"

enum actions {SHOW = 1, HIDE = 2, ATTACH = 3}

var monster_to_attack: MonsterCard

var turn_gen: TurnBasedGen = TurnBasedGen.new()

func _ready() -> void:
	turn_gen.set_variables(card_piles.get_child(0), card_piles.get_child(1), player)
	hide_button()

func do(action: Array) -> void:
	match action[0]:
		actions.SHOW:
			show_button()
		actions.HIDE:
			hide_button()
		actions.ATTACH:
			var monster: MonsterCard = action[1]
			attach_to_card(monster)

func show_button() -> void:
	attack_monster_button.visible = true
	attack_monster_button.disabled = false

func hide_button() -> void:
	attack_monster_button.visible = false
	attack_monster_button.disabled = true

func attach_to_card(monster: MonsterCard) -> void:
	attack_monster_button.position = Vector2(monster.position.x - BUTTON_ATTACH_X_UPDATE, monster.position.y - BUTTON_ATTACH_Y_UPDATE)
	monster_to_attack = monster
	show_button()

func _on_attack_monster_button_pressed() -> void:
	monster_manager.player_attack(player)
	monster_manager.unselect_monster()
