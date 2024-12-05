extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	var menu = preload("res://src/Scenes/Menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene = menu
