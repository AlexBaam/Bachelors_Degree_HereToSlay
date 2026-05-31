extends Node

##Parent class defining the concept of the state that should be followed by every class that inherits from it
class_name State

signal Transitioned

func enter() -> void:
	pass

func exit() -> void:
	pass 

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass
