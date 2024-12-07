extends Control

@export var winner_sfx = preload("res://src/Assets/Sounds/BGM/[4]winner.wav")
@export var button_sfx = preload("res://src/Assets/Sounds/BGM/[8]button.wav")
@onready var winner: AudioStreamPlayer2D = $win
@onready var button: AudioStreamPlayer2D = $button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if winner:
		winner.stream = winner_sfx
		winner.play()

func play_button_sfx() -> void:
	if button:
		button.stream = button_sfx
		button.play()

func _on_button_pressed() -> void:
	play_button_sfx()
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	var menu = preload("res://src/Scenes/Menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene = menu
