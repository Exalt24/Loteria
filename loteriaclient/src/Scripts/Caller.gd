extends Node

signal card_called(called_card: Texture)  # Signal to notify about the called card

@export var loterya_cards: Array = [
	preload("res://src/Assets/Images/Loterya Cards/Agila.png"),
	preload("res://src/Assets/Images/Loterya Cards/Anahaw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Arnis.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bahay Kubo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bakya.png"),
	preload("res://src/Assets/Images/Loterya Cards/Balut.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bangus.png"),
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
	preload("res://src/Assets/Images/Loterya Cards/Maskara.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pagmamano.png"),
]

var remaining_cards = []  # Cards not yet called

@onready var caller_display: TextureRect = $CallerDisplay  # Correctly reference the TextureRect node
var timer: Timer  # Declare a variable for the timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize the remaining cards and shuffle them
	remaining_cards = loterya_cards.duplicate()
	remaining_cards.shuffle()

	# Create and set up the timer
	timer = Timer.new()
	add_child(timer)  # Add the timer as a child of the current node
	timer.wait_time = 3.0
	timer.one_shot = false  # Set to false so it repeats automatically
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	# Start the timer
	timer.start()

func _on_Timer_timeout() -> void:
	# Check if there are cards left to call
	if remaining_cards.size() > 0:
		var called_card = remaining_cards.pop_front()  # Get the next card
		emit_signal("card_called", called_card)  # Emit the signal with the called card

		# Display the called card in the UI
		caller_display.texture = called_card
	else:
		$Timer.stop()
		print("All cards have been called!")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
