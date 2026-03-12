extends Node2D

const HAND_COUNT = 5
const CARD_SCENE_PATH = "res://Scenes/Card.tscn"
const CARDS_DATABASE_PATH = "res://Scripts/cards_database.gd"

var game_card_pile = ["Bard", "Wizard", "Fighter", "Paladin", "Ranger", "Rogue"]
var card_databate_reference

@export var card_draw_speed = 0.5

@onready var player_hand_reference: Node2D = $"../../PlayerHand"
@onready var card_manager_reference: Node2D = $"../../CardManager"
@onready var cards_left_reference: RichTextLabel = $RichTextLabel
@onready var card_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var card_sprite: Sprite2D = $Sprite2D
@onready var card_name: RichTextLabel = $CardName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_card_pile.shuffle() # Shuffling the deck for random cards
	cards_left_reference.text = str(game_card_pile.size())
	card_databate_reference = preload(CARDS_DATABASE_PATH)

func draw_card():
	var card_drawn_name = game_card_pile[0]
	game_card_pile.erase(card_drawn_name)
	
	# Setting the deck to invisible if there are no cards left
	if game_card_pile.size() == 0:
		card_collider.disabled = true
		card_sprite.visible = false
		cards_left_reference.visible = false
	
	cards_left_reference.text = str(game_card_pile.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	
	# Custom card images"
	var card_image_path = str("res://Textures/Cards/"+ card_drawn_name +".png")
	new_card.get_node("CardImage").texture = load(card_image_path)
	
	# Settings the dice roll and the description of the card
	new_card.get_node("DiceRoll").text = str(card_databate_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Description").text = str(card_databate_reference.CARDS[card_drawn_name][1])
	new_card.get_node("CardName").text = str(card_drawn_name)
	
	card_manager_reference.add_child(new_card)
	# Adaugam in player hand o carte, acea entitate carte va avea acelasi nume cu ce carte reprezinta ea
	new_card.name = card_drawn_name
	player_hand_reference.add_card_to_hand(new_card, card_draw_speed)
