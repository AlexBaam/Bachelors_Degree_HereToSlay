extends Node

class_name ChooseEnemy

var enemy1: Button
var enemy2: Button
var enemy3: Button

var all_buttons: Array[Button]

var button_pressed: int

signal any_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	define_children()
	
	all_buttons.append(enemy1)
	all_buttons.append(enemy2)
	all_buttons.append(enemy3)
	
	hide_buttons()
	
	$".".position.x = get_viewport().size.x/2
	$".".position.y = get_viewport().size.y/2

func define_children() -> void:
	var buttons: Array = get_children()
	
	enemy1 = buttons[0]
	enemy2 = buttons[1]
	enemy3 = buttons[2]

func hide_buttons() -> void:
	for button in all_buttons:
		button.visible = false
		button.disabled = true

func show_buttons() -> void:
	for button in all_buttons:
		button.visible = true
		button.disabled = false

func _on_enemy_1_pressed() -> void:
	button_pressed = 1
	hide_buttons()
	emit_signal("any_button_pressed")

func _on_enemy_2_pressed() -> void:
	button_pressed = 2
	hide_buttons()
	emit_signal("any_button_pressed")

func _on_enemy_3_pressed() -> void:
	button_pressed = 3
	hide_buttons()
	emit_signal("any_button_pressed")

func get_button_pressed() -> int:
	return button_pressed
