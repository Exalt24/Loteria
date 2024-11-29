extends Control

@onready var caller_display: TextureRect = $Panel/CallerDisplay
@onready var time_bar: Line2D = $Panel/TimeBar
@onready var goal_pattern: Panel = $Panel/pattern

func _ready() -> void:
	if Client.win_condition != null:
		print(Client.win_condition)
		set_goal_pattern(Client.win_condition)
	else:
		print("No win condition set")

func set_goal_pattern(number_pattern: int) -> void:
	var patterns = [
		preload("res://src/Assets/Images/Pattern/Column.png"),
		preload("res://src/Assets/Images/Pattern/Row.png"),
		preload("res://src/Assets/Images/Pattern/Square.png"),
		preload("res://src/Assets/Images/Pattern/Cross.png")
	]
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = patterns[number_pattern]
	 # Set content margins
	stylebox.set_content_margin_all(20)
	
	goal_pattern.add_theme_stylebox_override("panel", stylebox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
