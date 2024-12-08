extends Label

@export var countdown_fx = preload("res://src/Assets/Sounds/BGM/[6]timer.wav")
@onready var audio_player: AudioStreamPlayer2D = $"../../countdown"
var countdown = 3

# Timer to control the countdown
var timer = 0.0

func _ready() -> void:
	text = str(countdown)  # Initialize the label text with the countdown start value

func _process(delta: float) -> void:
	timer += delta
	if timer >= 1.0:  # One second has passed
		timer = 0.0
		countdown -= 1
		if countdown > 0:
			text = str(countdown)  # Update the label text
		else:
			text = ""  # Clear the text or perform other actions once countdown finishes
			set_process(false)  # Stop processing further
