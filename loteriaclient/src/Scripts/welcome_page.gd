extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# List of TextureRects representing letters
	var letters = [
		$LetterL,
		$LetterO,
		$LetterT,
		$LetterE,
		$LetterR,
		$LetterY,
		$LetterA
	]

	# Initial animation setup
	var delay = 0.0
	for letter in letters:
		# Start with the letter scaled to zero and invisible
		letter.scale = Vector2(0, 0)
		letter.visible = true  # Ensure the image is visible

		# Create a SceneTreeTween for this letter
		var tween = create_tween()
		
		# Add a delay for each letter to animate sequentially
		tween.tween_interval(delay)
		
		# Set the easing and transition styles for bounce effect
		tween.tween_easing(Tween.EASE_OUT)
		tween.tween_transition(Tween.TRANS_BOUNCE)

		# Animate the letter popping up (scale animation)
		tween.tween_property(letter, "scale", Vector2(1.2, 1.2), 0.2)

		# Animate scaling back to normal
		tween.tween_easing(Tween.EASE_IN)
		tween.tween_transition(Tween.TRANS_LINEAR)
		tween.tween_property(letter, "scale", Vector2(1, 1), 0.2)

		# Increment delay for the next letter
		delay += 0.3
