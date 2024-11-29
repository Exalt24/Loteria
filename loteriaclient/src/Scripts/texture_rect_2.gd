extends TextureRect

var patterns = [
	preload("res://src/Assets/Images/Pattern/Column.png"),
	preload("res://src/Assets/Images/Pattern/Row.png"),
	preload("res://src/Assets/Images/Pattern/Square.png"),
	preload("res://src/Assets/Images/Pattern/Cross.png")
]

func _ready() -> void:
	if Client.win_condition != null:
		_update_texture(Client.win_condition)
	else:
		print("Win condition not set yet.")

func _update_texture(win_condition: int) -> void:
	if win_condition >= 0 and win_condition < patterns.size():
		texture = patterns[win_condition]
		print("Texture updated based on win condition: ", win_condition)
	else:
		print("Invalid win condition index: ", win_condition)
