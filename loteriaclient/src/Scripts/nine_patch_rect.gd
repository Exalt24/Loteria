extends NinePatchRect

@onready var loterya_cards: Array = [
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Agila.png"), "index": 0},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Anahaw.png"), "index": 1},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Arnis.png"), "index": 2},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bahay Kubo.png"), "index": 3},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bakya.png"), "index": 4},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Balut.png"), "index": 5},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bangus.png"), "index": 6},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Banig.png"), "index": 7},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Baro.png"), "index": 8},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Barong.png"), "index": 9},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bayanihan.png"), "index": 10},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bolo.png"), "index": 11},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Buko.png"), "index": 12},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bulalo.png"), "index": 13},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Duwende.png"), "index": 14},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Halo-Halo.png"), "index": 15},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Harana.png"), "index": 16},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Isaw.png"), "index": 17},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Jeepney.png"), "index": 18},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Kalesa.png"), "index": 19},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Kulintang.png"), "index": 20},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Lechon.png"), "index": 21},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Mangga.png"), "index": 22},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Maskara.png"), "index": 23},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Pagmamano.png"), "index": 24},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Palay.png"), "index": 25},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Pamaypay.png"), "index": 26},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Pandesal.png"), "index": 27},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Parol.png"), "index": 28},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Piyesta.png"), "index": 29},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Puso.png"), "index": 30},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Puto.png"), "index": 31},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Rice Terraces.png"), "index": 32},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Salakot.png"), "index": 33},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Sampaguita.png"), "index": 34},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Sungka.png"), "index": 35},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Taho.png"), "index": 36},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tamaraw.png"), "index": 37},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tarsier.png"), "index": 38},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tindahan.png"), "index": 39},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tinikling.png"), "index": 40},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tumbang Preso.png"), "index": 41},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Vinta.png"), "index": 42},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Walis Tambo.png"), "index": 43},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Watawat.png"), "index": 44}
]

var card_items = []  # Cards to display
var slots  # Slots to display cards
var caller_card_index = -1  # Store the current caller card index

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

	# Get random 16 cards from the loterya_cards
	card_items = get_random_cards(16)

	# Set the selected cards to the card display
	set_card_data(card_items)
	
	# Connect signals for each slot to detect clicks
	for i in range(slots.size()):
		var slot = slots[i]
		if slot is TextureRect:
			slot.set_meta("index", i)  # Store the index in the slot's metadata
			slot.connect("gui_input", Callable(self, "_on_card_clicked").bind(slot))  # Bind the slot to the signal

# Function to randomly select cards
func get_random_cards(count: int) -> Array:
	var shuffled = loterya_cards.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, count)  # Take the first `count` items

# Function to set card data
func set_card_data(items: Array) -> void:
	card_items = items
	update_card_display()

# Function to update the card's display
func update_card_display() -> void:
	# Loop through the slots and assign corresponding images from card_items
	for i in range(min(card_items.size(), slots.size())):
		var slot = slots[i]
		if slot is TextureRect:
			slot.texture = card_items[i]["texture"]  # Set the preloaded texture directly

func update_caller_card(new_caller_index: int) -> void:
	caller_card_index = new_caller_index

func _on_card_clicked(event: InputEvent, slot: TextureRect) -> void:
	if event is InputEventMouseButton and event.pressed:
		var card_index = slot.get_meta("index")  # Get the card index stored in the metadata
		var card_data = card_items[card_index]  # Retrieve the card data
		if card_data["index"] == caller_card_index:
			if not marked_cards.has(card_index):
				marked_cards.append(card_index)
				update_matrix(card_index)
				mark_card_with_coin(slot)
		else:
			print("Clicked card does not match the caller card index.")

# Function to update the matrix_presentation
func update_matrix(card_index: int) -> void:
	var row = card_index / 4
	var col = card_index % 4

	matrix_presentation[row][col] = 1
	
	print("Updated Matrix Presentation: ", matrix_presentation)
	Client.check_for_pattern_match(matrix_presentation)

func mark_card_with_coin(slot: TextureRect) -> void:
	var coin = Sprite2D.new()
	coin.texture = coin_texture

	var original_size = coin.texture.get_size()
	var scale_factor = Vector2(50, 50) / original_size
	coin.scale = scale_factor

	var slot_size = slot.get_rect().size

	coin.position = slot_size / 2 - Vector2(25, 25)

	slot.add_child(coin)
