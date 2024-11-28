extends TextureRect

# Array of texture paths for the patterns
var patterns = [
	preload("res://src/Assets/Images/PatternBG/Column.png"),
	preload("res://src/Assets/Images/PatternBG/Row.png"),
	preload("res://src/Assets/Images/PatternBG/Square.png"),
	preload("res://src/Assets/Images/PatternBG/Cross.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Ensure randomness
	randomize()

	# If the pattern has not been selected globally, select one randomly
	if GameState.selected_pattern == null:
		GameState.selected_pattern = patterns[randi() % patterns.size()]

	# Apply the shared pattern to this TextureRect instance
	texture = GameState.selected_pattern
