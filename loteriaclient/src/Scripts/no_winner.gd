extends Control

@export var loser_sfx = preload("res://src/Assets/Sounds/BGM/[5]loser.wav")
@export var button_sfx = preload("res://src/Assets/Sounds/BGM/[8]button.wav")

@onready var loser: AudioStreamPlayer2D = $draw
@onready var button: AudioStreamPlayer2D = $button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if loser:
		loser.stream = loser_sfx
		loser.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
