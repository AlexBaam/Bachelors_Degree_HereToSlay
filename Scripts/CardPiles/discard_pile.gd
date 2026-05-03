extends Node2D

class_name DiscardPile

const PLAYER_CARD_SCENE_PATH = "res://Scenes/Cards/PlayerCards.tscn"
const ENEMY_CARD_SCENE_PATH = "res://Scenes/Cards/EnemyCards.tscn"
const CARDS_DATABASE_PATH = "res://Scripts/GameData/cards_database.gd"

var card_databate_reference: Resource = preload(CARDS_DATABASE_PATH)

@export var card_draw_speed : float = 0.5

@onready var card_manager: CardManager = $"../../CardManager"
@onready var cards_in_discard_pile: RichTextLabel = $RichTextLabel
@onready var discard_pile_sprite: Sprite2D = $Sprite2D
@onready var discard_pile_collider: CollisionShape2D = $Area2D/CollisionShape2D

var game_discard_pile: Array[String] = []

# CardPileGenerals class instance
# Used for generalising redundant code
var card_pile_gen : CardPileGenerals = CardPileGenerals.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if game_discard_pile.size() == 0:
		card_pile_gen.pile_visibility(false, discard_pile_sprite, cards_in_discard_pile)

func sanitize_card_names(card_name: String) -> String:
	var sanitized_card_name: String 
	
	for char in str(card_name):
		if not char.is_valid_int():
			sanitized_card_name = sanitized_card_name + char
			
	print(sanitized_card_name)
	return sanitized_card_name

# A function to update the discard pile by adding a card
func add_to_discard_pile(card: CardClass) -> void:
	if game_discard_pile.size() == 0:
		card_pile_gen.pile_visibility(true, discard_pile_sprite, cards_in_discard_pile)
	
	# Adaugam carti in discard pile (adica array, strict doar numele cartii)
	# Crestem nr de carti in discard pile
	# Eliminam cartea din memorie
	var card_name: String = sanitize_card_names(card.name)
	game_discard_pile.append(card_name)
	cards_in_discard_pile.text = str(game_discard_pile.size())
	card.queue_free()

# We empty the discard pile so after refilling the card pile we can delete it
func empty_discard_pile() -> void:
	game_discard_pile.clear()
	card_pile_gen.pile_visibility(false, discard_pile_sprite, cards_in_discard_pile)

func get_discard_pile_position() -> Vector2:
	return Vector2(position.x, position.y)

func get_discard_pile_size() -> int:
	return game_discard_pile.size()

func draw_discarded_card(player_hand: PlayerHand) -> void:
	card_manager.unselect_card()
	
	var card_drawn_name : String = game_discard_pile[0]
	game_discard_pile.erase(card_drawn_name)
	
	# Setting the deck to invisible if there are no cards left
	if game_discard_pile.size() == 0:
		discard_pile_collider.disabled = true
		card_pile_gen.pile_visibility(false,discard_pile_sprite,cards_in_discard_pile)
	
	cards_in_discard_pile.text = str(game_discard_pile.size())
	var card_scene: Resource = preload(PLAYER_CARD_SCENE_PATH)
	var new_card: CardClass = card_scene.instantiate()
	
	# Custom card images
	var card_image_path : String = str("res://Textures/Cards/"+ card_drawn_name +".png")
	new_card.get_node("CardImageFront").texture = load(card_image_path)
	
	# Settings the dice roll and the description of the card
	new_card.get_node("DiceRoll").text = card_databate_reference.CARDS[card_drawn_name][0]
	new_card.get_node("Description").text = card_databate_reference.CARDS[card_drawn_name][1]
	
	# Setting a name on the card so we know what card we dragged
	new_card.get_node("CardName").text = card_drawn_name
	
	# Settings the card type and class of a card
	new_card.card_dice_roll = int(card_databate_reference.CARDS[card_drawn_name][0])
	new_card.card_type = card_databate_reference.CARDS[card_drawn_name][2]
	new_card.card_class = card_databate_reference.CARDS[card_drawn_name][3]
	
	card_manager.add_child(new_card)
	# Adaugam in player hand o carte, acea entitate carte va avea acelasi nume cu ce carte reprezinta ea
	new_card.name = card_drawn_name
	player_hand.add_card_to_hand(new_card, card_draw_speed)
	
	# Animatie simpla de card flip ptr cartile noastre
	new_card.get_node("CardFlipAnimation").play("card_flip")
