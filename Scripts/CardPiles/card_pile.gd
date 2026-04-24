extends Node2D

const CARD_SCENE_PATH = "res://Scenes/Cards/PlayerCards.tscn"
const ENEMY_CARD_SCENE_PATH = "res://Scenes/Cards/EnemyCards.tscn"
const CARDS_DATABASE_PATH = "res://Scripts/GameData/cards_database.gd"

var game_card_pile : Array[String] = ["Bard", "Wizard", "Fighter", "Paladin", "Ranger", "Rogue",
 "Bard", "Wizard", "Fighter", "Paladin", "Ranger", "Rogue",
 "Bard", "Wizard", "Fighter", "Paladin", "Ranger", "Rogue"]

var card_databate_reference: Resource = preload(CARDS_DATABASE_PATH)

@export var card_draw_speed : float = 0.5

@onready var discard_pile_reference: Node2D = $"../DiscardPile"
@onready var card_manager_reference: Node2D = $"../../CardManager"
@onready var cards_left_reference: RichTextLabel = $RichTextLabel
@onready var card_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var card_sprite: Sprite2D = $Sprite2D
@onready var card_name: RichTextLabel = $CardName

# CardPileGenerals class instance
# Used for generalising redundant code
var card_pile_gen : CardPileGen = CardPileGen.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_card_pile.shuffle() # Shuffling the deck for random cards
	cards_left_reference.text = str(game_card_pile.size())

func get_discard_pile_size() -> int:
	return discard_pile_reference.game_discard_pile.size()

func draw_card(player_hand: Node2D) -> void:
	card_manager_reference.unselect_card()
	
	var card_drawn_name : String = game_card_pile[0]
	game_card_pile.erase(card_drawn_name)
	
	# Setting the deck to invisible if there are no cards left
	if game_card_pile.size() == 0:
		if get_discard_pile_size() > 0:
			game_card_pile = discard_pile_reference.game_discard_pile.duplicate(true)
			game_card_pile.shuffle()
			cards_left_reference.text = str(game_card_pile.size())
			discard_pile_reference.empty_discard_pile()
		else:
			card_collider.disabled = true
			card_pile_gen.pile_visibility(false,card_sprite,cards_left_reference)
	
	cards_left_reference.text = str(game_card_pile.size())
	var card_scene: Resource = preload(CARD_SCENE_PATH)
	var new_card: Card = card_scene.instantiate()
	
	# Custom card images
	var card_image_path : String = str("res://Textures/Cards/"+ card_drawn_name +".png")
	new_card.get_node("CardImageFront").texture = load(card_image_path)
	
	# Settings the dice roll and the description of the card
	new_card.get_node("DiceRoll").text = card_databate_reference.CARDS[card_drawn_name][0]
	new_card.get_node("Description").text = card_databate_reference.CARDS[card_drawn_name][1]
	
	# Setting a name on the card so we know what card we dragged
	new_card.get_node("CardName").text = card_drawn_name
	
	# Settings the card type and class of a card
	new_card.card_type = card_databate_reference.CARDS[card_drawn_name][2]
	new_card.card_class = card_databate_reference.CARDS[card_drawn_name][3]
	new_card.card_dice_roll = card_databate_reference.CARDS[card_drawn_name][0]
	
	card_manager_reference.add_child(new_card)
	# Adaugam in player hand o carte, acea entitate carte va avea acelasi nume cu ce carte reprezinta ea
	new_card.name = card_drawn_name
	player_hand.add_card_to_hand(new_card, card_draw_speed)
	
	# Animatie simpla de card flip ptr cartile noastre
	new_card.get_node("CardFlipAnimation").play("card_flip")

func enemy_draw_card(enemy_hand: Node2D) -> void:
	var card_drawn_name : String = game_card_pile[0]
	game_card_pile.erase(card_drawn_name)
	
	# Setting the deck to invisible if there are no cards left
	if game_card_pile.size() == 0:
		if get_discard_pile_size() > 0:
			game_card_pile = discard_pile_reference.game_discard_pile.duplicate(true)
			game_card_pile.shuffle()
			cards_left_reference.text = str(game_card_pile.size())
			discard_pile_reference.empty_discard_pile()
		else:
			card_collider.disabled = true
			card_pile_gen.pile_visibility(false,card_sprite,cards_left_reference)
	
	cards_left_reference.text = str(game_card_pile.size())
	var card_scene: Resource = preload(ENEMY_CARD_SCENE_PATH)
	var new_card: Node = card_scene.instantiate()
	
	# Custom card images
	var card_image_path : String = str("res://Textures/Cards/"+ card_drawn_name +".png")
	new_card.get_node("CardImageFront").texture = load(card_image_path)
	
	# Settings the dice roll and the description of the card
	new_card.get_node("DiceRoll").text = card_databate_reference.CARDS[card_drawn_name][0]
	new_card.get_node("Description").text = card_databate_reference.CARDS[card_drawn_name][1]
	
	# Setting a name on the card so we know what card we dragged
	new_card.get_node("CardName").text = card_drawn_name
	
	# Settings the card type and class of a card
	new_card.card_type = card_databate_reference.CARDS[card_drawn_name][2]
	new_card.card_class = card_databate_reference.CARDS[card_drawn_name][3]
	
	card_manager_reference.add_child(new_card)
	# Adaugam in player hand o carte, acea entitate carte va avea acelasi nume cu ce carte reprezinta ea
	new_card.name = card_drawn_name
	enemy_hand.add_card_to_hand(new_card, card_draw_speed)
