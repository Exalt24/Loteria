extends NinePatchRect

var to_display_id 
var slots  # Slots to display cards
var caller_card_index = -1  # Store the current caller card index
var matrix_to_copy =  [
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0]
]
var marked_cards = []  # Array to store marked card indices
var matrix_presentation = [
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0]
]
@onready var coin_texture = preload("res://src/Assets/Images/coin.png")  # Coin texture to mark a card

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Initialize the slots variable by getting all children of the Grid node
	slots = $GridContainer.get_children()
	
	if Client.the_winner_id != -1:
		to_display_id = Client.the_winner_id
		
	else:
		to_display_id = Client.client_id
	print(Client.opponent_matrices)
	print("Client ID Winner",Client.the_winner_id, " to_displayy_ID",to_display_id )
	 # Validate that opponent_matrices is a dictionary and contains the key
	if Client.opponent_matrices is Dictionary and Client.opponent_matrices.has(to_display_id):
		matrix_to_copy = Client.opponent_matrices[to_display_id]
	else:
		print("Opponent matrix is either not a dictionary or does not contain the key: ", to_display_id)
		return  # Exit if the matrix is invalid
	# Get random 16 cards from the loterya_cards

	# Set the selected cards to the card display
	var index = 0
	for row in matrix_to_copy:
		for value in row:
			if value == 1:
				var slot = slots[index]
				if slot is TextureRect:
					mark_card_with_coin(slot)
			index+=1

func mark_card_with_coin(slot: TextureRect) -> void:

	var token_textures: Dictionary = {
		"marble": preload("res://src/Assets/Images/Articles/bola.png"),
		"can": preload("res://src/Assets/Images/Articles/lata.png"),
		"slippers": preload("res://src/Assets/Images/Articles/tsinelas.png"),
		"takyan": preload("res://src/Assets/Images/Articles/takyan.png"),
		"atis": preload("res://src/Assets/Images/Articles/prutas.png"),
	}
	var coin = Sprite2D.new()
	coin.texture = token_textures[Client.opponent_tokens[to_display_id]]

	var original_size = coin.texture.get_size()
	var scale_factor = Vector2(100, 100) / original_size
	coin.scale = scale_factor

	var slot_size = slot.get_rect().size

	coin.position = slot_size / 2 - Vector2(0, 0)

	slot.add_child(coin)
