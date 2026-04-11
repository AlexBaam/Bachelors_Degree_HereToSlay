extends StaticBody2D

@onready var faces: Node2D = $Faces

var rolling_dice: bool = false
var current_face: int = 0

func _ready() -> void:
	hide_faces()

func hide_faces() -> void:
	for face in faces.get_children():
		face.hide()

func can_roll() -> bool:
	return !rolling_dice

func roll_die() -> int: 
	var duration: float = 1.0
	
	rolling_dice = true
	
	while duration > 0:
		var new_face: int = faces.get_children().pick_random().get_index()
		faces.get_child(current_face).hide()
		faces.get_child(new_face).show()
		
		await get_tree().create_timer(0.1).timeout
		
		current_face = new_face
		duration = duration - 0.1
		
	rolling_dice = false
	
	print("By rollign we got: ", current_face + 1)
	return current_face + 1
