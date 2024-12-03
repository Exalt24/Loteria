extends Control

@onready var caller_display: TextureRect = $Panel/CallerDisplay
@onready var time_bar: Line2D = $Panel/Panel/TimeBar
@onready var goal_pattern: Panel = $Panel/pattern
@onready var nine_patch_rect: NinePatchRect = $Panel/NinePatchRect
@onready var loterya_button: Button = $Panel/Button

func _ready() -> void:
	loterya_button.disabled = true
	if Client.win_condition != null:
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

func _on_loterya_button_pressed() -> void:
	loterya_button.set_pressed_no_signal(false)
	loterya_button.release_focus()
	Client.winner_game()
