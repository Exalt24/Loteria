extends Label

# Countdown start value
var countdown = 3

# Timer to control the countdown
var timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(countdown)  # Initialize the label text with the countdown start value

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
