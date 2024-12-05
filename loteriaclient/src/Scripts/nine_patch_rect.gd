extends NinePatchRect

@onready var sound_player = $AudioStreamPlayer2D
@onready var loterya_cards: Array = [
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Agila.png"), "index": 0, "sound": preload("res://src/Assets/Sounds/Agila.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Anahaw.png"), "index": 1, "sound": preload("res://src/Assets/Sounds/Anahaw.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Arnis.png"), "index": 2, "sound": preload("res://src/Assets/Sounds/Arnis.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bahay Kubo.png"), "index": 3, "sound": preload("res://src/Assets/Sounds/Bahay Kubo.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bakya.png"), "index": 4, "sound": preload("res://src/Assets/Sounds/Bakya.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Balut.png"), "index": 5, "sound": preload("res://src/Assets/Sounds/Balut.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bangus.png"), "index": 6, "sound": preload("res://src/Assets/Sounds/Bangus.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Banig.png"), "index": 7, "sound": preload("res://src/Assets/Sounds/Banig.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Baro.png"), "index": 8, "sound": preload("res://src/Assets/Sounds/Baro.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Barong.png"), "index": 9, "sound": preload("res://src/Assets/Sounds/Barong.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bayanihan.png"), "index": 10, "sound": preload("res://src/Assets/Sounds/Bayanihan.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bolo.png"), "index": 11, "sound": preload("res://src/Assets/Sounds/Bolo.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Buko.png"), "index": 12, "sound": preload("res://src/Assets/Sounds/Buko.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Bulalo.png"), "index": 13, "sound": preload("res://src/Assets/Sounds/Bulalo.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Duwende.png"), "index": 14, "sound": preload("res://src/Assets/Sounds/Duwende.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Halo-Halo.png"), "index": 15, "sound": preload("res://src/Assets/Sounds/Halo-Halo.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Harana.png"), "index": 16, "sound": preload("res://src/Assets/Sounds/Harana.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Isaw.png"), "index": 17, "sound": preload("res://src/Assets/Sounds/Isaw.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Jeepney.png"), "index": 18, "sound": preload("res://src/Assets/Sounds/Jeepney.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Kalesa.png"), "index": 19, "sound": preload("res://src/Assets/Sounds/Kalesa.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Kulintang.png"), "index": 20, "sound": preload("res://src/Assets/Sounds/Kulintang.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Lechon.png"), "index": 21, "sound": preload("res://src/Assets/Sounds/Lechon.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Mangga.png"), "index": 22, "sound": preload("res://src/Assets/Sounds/Mangga.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Maskara.png"), "index": 23, "sound": preload("res://src/Assets/Sounds/Maskara.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Pagmamano.png"), "index": 24, "sound": preload("res://src/Assets/Sounds/Pagmamano.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Palay.png"), "index": 25, "sound": preload("res://src/Assets/Sounds/Palay.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Pamaypay.png"), "index": 26, "sound": preload("res://src/Assets/Sounds/Pamaypay.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Pandesal.png"), "index": 27, "sound": preload("res://src/Assets/Sounds/Pandesal.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Parol.png"), "index": 28, "sound": preload("res://src/Assets/Sounds/Parol.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Piyesta.png"), "index": 29, "sound": preload("res://src/Assets/Sounds/Piyesta.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Puso.png"), "index": 30, "sound": preload("res://src/Assets/Sounds/Puso.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Puto.png"), "index": 31, "sound": preload("res://src/Assets/Sounds/Puto.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Rice Terraces.png"), "index": 32, "sound": preload("res://src/Assets/Sounds/Rice Terraces.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Salakot.png"), "index": 33, "sound": preload("res://src/Assets/Sounds/Salakot.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Sampaguita.png"), "index": 34, "sound": preload("res://src/Assets/Sounds/Sampaguita.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Sungka.png"), "index": 35, "sound": preload("res://src/Assets/Sounds/Sungka.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Taho.png"), "index": 36, "sound": preload("res://src/Assets/Sounds/Taho.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tamaraw.png"), "index": 37, "sound": preload("res://src/Assets/Sounds/Tamaraw.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tarsier.png"), "index": 38, "sound": preload("res://src/Assets/Sounds/Tarsier.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tindahan.png"), "index": 39, "sound": preload("res://src/Assets/Sounds/Tindahan.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tinikling.png"), "index": 40, "sound": preload("res://src/Assets/Sounds/Tinikling.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Tumbang Preso.png"), "index": 41, "sound": preload("res://src/Assets/Sounds/Tumbang-Preso.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Vinta.png"), "index": 42, "sound": preload("res://src/Assets/Sounds/Vinta.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Walis Tambo.png"), "index": 42, "sound": preload("res://src/Assets/Sounds/Walis Tambo.wav")},
	{"texture": preload("res://src/Assets/Images/Loterya Cards/Watawat.png"), "index": 42, "sound": preload("res://src/Assets/Sounds/Watawat.wav")}
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
	
	# Get the caller card data
	var caller_card = loterya_cards[caller_card_index]
	
	# Play the associated sound
	if caller_card.has("sound"):
		sound_player.stream = caller_card["sound"]
		sound_player.play()
	else:
		print("No sound available for the caller card:", caller_card_index)

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
	var scale_factor = Vector2(100, 100) / original_size
	coin.scale = scale_factor

	var slot_size = slot.get_rect().size

	coin.position = slot_size / 2 - Vector2(0, 0)

	slot.add_child(coin)
