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

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Initialize the slots variable by getting all children of the Grid node
	slots = $GridContainer.get_children()

	# Get random 16 cards from the loterya_cards
	card_items = get_random_cards(16)

	# Set the selected cards to the card display
	set_card_data(card_items)

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
