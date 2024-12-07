extends Control

@export var timer_sfx = preload("res://src/Assets/Sounds/BGM/[6]timer.wav")
@onready var timer: AudioStreamPlayer2D = $countdown

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if timer:
		timer.stream = timer_sfx
		timer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
