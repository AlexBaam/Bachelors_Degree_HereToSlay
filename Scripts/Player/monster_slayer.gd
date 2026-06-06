extends Node2D
class_name MonsterSlayer

## This value represents how much I have to substract from the position of the button attached to the center of the card to be above it
const BUTTON_ATTACH_Y_UPDATE: int = 110

## This value represents how much I have to substract from the position of the button attached to the center of the card to centered with it
const BUTTON_ATTACH_X_UPDATE: int = 26

@onready var attack_monster_button: Button = $AttackMonsterButton
@onready var player: PlayerClass = $".."

## The card monster selected by the player to attack
var monster_to_attack: MonsterCard

signal request_attack_monster(monster: MonsterCard)
signal request_monster_unselect()

func _ready() -> void:
	self.hide_button()

func show_button() -> void:
	attack_monster_button.visible = true
	attack_monster_button.disabled = false

func hide_button() -> void:
	attack_monster_button.visible = false
	attack_monster_button.disabled = true

func attach_to_card(monster: MonsterCard) -> void:
	attack_monster_button.position = Vector2(monster.position.x - BUTTON_ATTACH_X_UPDATE, monster.position.y - BUTTON_ATTACH_Y_UPDATE)
	monster_to_attack = monster
	self.show_button()

func _on_attack_monster_button_pressed() -> void:
	request_attack_monster.emit(monster_to_attack)
	request_monster_unselect.emit()
	self.hide_button()
