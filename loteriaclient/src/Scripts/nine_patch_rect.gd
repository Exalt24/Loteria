extends NinePatchRect

@onready var loterya_cards: Array = [
	preload("res://src/Assets/Images/Loterya Cards/Agila.png"),
	preload("res://src/Assets/Images/Loterya Cards/Anahaw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Arnis.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bahay Kubo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bakya.png"),
	preload("res://src/Assets/Images/Loterya Cards/Balut.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bangus.png"),
	preload("res://src/Assets/Images/Loterya Cards/Banig.png"),
	preload("res://src/Assets/Images/Loterya Cards/Baro.png"),
	preload("res://src/Assets/Images/Loterya Cards/Barong.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bayanihan.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bolo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Buko.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bulalo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Duwende.png"),
	preload("res://src/Assets/Images/Loterya Cards/Halo-Halo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Harana.png"),
	preload("res://src/Assets/Images/Loterya Cards/Isaw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Jeepney.png"),
	preload("res://src/Assets/Images/Loterya Cards/Kalesa.png"),
	preload("res://src/Assets/Images/Loterya Cards/Kulintang.png"),
	preload("res://src/Assets/Images/Loterya Cards/Lechon.png"),
	preload("res://src/Assets/Images/Loterya Cards/Mangga.png"),
	preload("res://src/Assets/Images/Loterya Cards/Maskara.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pagmamano.png"),
	preload("res://src/Assets/Images/Loterya Cards/Palay.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pamaypay.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pandesal.png"),
	preload("res://src/Assets/Images/Loterya Cards/Parol.png"),
	preload("res://src/Assets/Images/Loterya Cards/Piyesta.png"),
	preload("res://src/Assets/Images/Loterya Cards/Puso.png"),
	preload("res://src/Assets/Images/Loterya Cards/Puto.png"),
	preload("res://src/Assets/Images/Loterya Cards/Rice Terraces.png"),
	preload("res://src/Assets/Images/Loterya Cards/Salakot.png"),
	preload("res://src/Assets/Images/Loterya Cards/Sampaguita.png"),
	preload("res://src/Assets/Images/Loterya Cards/Sungka.png"),
	preload("res://src/Assets/Images/Loterya Cards/Taho.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tamaraw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tarsier.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tindahan.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tinikling.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tumbang Preso.png"),
	preload("res://src/Assets/Images/Loterya Cards/Vinta.png"),
	preload("res://src/Assets/Images/Loterya Cards/Walis Tambo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Watawat.png")
]

var card_items = []  # Cards to display
var slots  # Slots to display cards
var caller_card_index = -1  # Store the current caller card index
var marked_cards = []  # Array to store marked card indices
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
	# Connect signals for each slot to detect clicks
	for i in range(slots.size()):
		var slot = slots[i]
		if slot is TextureRect:
			slot.set_meta("index", i)  # Store the index in the slot's metadata
			slot.connect("gui_input", Callable(self, "_on_card_clicked").bind(slot))  # Bind the slot to the signal

# Function to randomly select cards
func get_random_cards(count: int) -> Array:
	var shuffled = loterya_cards.duplicate()
	shuffled.shuffle()  # Randomize the order
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
			slot.texture = card_items[i]  # Set the preloaded texture directly

# Function to handle the caller card update from the server
func update_caller_card(new_caller_index: int) -> void:
	caller_card_index = new_caller_index

# Callback for card click
func _on_card_clicked(event: InputEvent, slot: TextureRect) -> void:
	if event is InputEventMouseButton and event.pressed:
		var clicked_card_index = slot.get_meta("index")  # Retrieve the index from metadata
		#if clicked_card_index != null and card_items[clicked_card_index] == loterya_cards[caller_card_index]:
		if clicked_card_index not in marked_cards:
			# Mark the card if not already marked
			mark_card_with_coin(slot)
			marked_cards.append(clicked_card_index)  # Add to marked cards array
			print("Marked cards:", marked_cards)  # Debugging output

# Function to mark a card with a coin
func mark_card_with_coin(slot: TextureRect) -> void:
	var coin = Sprite2D.new()
	coin.texture = coin_texture

	# Resize the coin to 50x50
	var original_size = coin.texture.get_size()
	var scale_factor = Vector2(50, 50) / original_size
	coin.scale = scale_factor

	# Get the size of the slot's rectangle
	var slot_size = slot.get_rect().size

	# Calculate the position to center the resized coin
	coin.position = slot_size / 2 - Vector2(25, 25)  # Center using the 50x50 size

	# Add the coin as a child of the slot
	slot.add_child(coin)
