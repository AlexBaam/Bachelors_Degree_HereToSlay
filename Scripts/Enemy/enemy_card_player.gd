extends Node2D
class_name  EnemyCardPlayer

func play(card: CardClass, target: Node) -> void:
	print("The card: " + str(card.name) + " will be played!")
	print("I will attack " + str(target))
