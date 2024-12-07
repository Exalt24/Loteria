extends Control

@export var background_music = preload("res://src/Assets/Sounds/BGM/[3]main.wav")

@onready var caller_display: TextureRect = $Panel/CallerDisplay
@onready var time_bar: Line2D = $Panel/Panel/TimeBar
@onready var goal_pattern: Panel = $Panel/pattern
@onready var nine_patch_rect: NinePatchRect = $Panel/NinePatchRect
@onready var loterya_button: Button = $Panel/Button

@onready var opp1: Control = $Panel/opponent/TextureRect
@onready var opp2: Control = $Panel/opponent/TextureRect2
@onready var opp3: Control = $Panel/opponent/TextureRect3
@onready var opp4: Control = $Panel/opponent/TextureRect4

@onready var audio_player: AudioStreamPlayer2D = $bgm


func _ready() -> void:
	#print("Current scene name: ", get_tree().current_scene.name)
	if audio_player:
		audio_player.stream = background_music
		audio_player.volume_db = -5.0
		audio_player.play()
	
	loterya_button.disabled = true
	if Client.win_condition != null:
		set_goal_pattern(Client.win_condition)
		set_opponents_texture()
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
	stylebox.set_content_margin_all(20)
	
	goal_pattern.add_theme_stylebox_override("panel", stylebox)

func _on_loterya_button_pressed() -> void:
	loterya_button.set_pressed_no_signal(false)
	loterya_button.release_focus()
	Client.winner_game()
	
func set_opponents_texture() -> void:
	var token_textures: Dictionary = {
		"marble": preload("res://src/Assets/Images/Opponent/Player1.png"),
		"can": preload("res://src/Assets/Images/Opponent/Player2.png"),
		"slippers": preload("res://src/Assets/Images/Opponent/Player3.png"),
		"takyan": preload("res://src/Assets/Images/Opponent/Player4.png"),
		"atis": preload("res://src/Assets/Images/Opponent/Player5.png"),
		"nomarble": preload("res://src/Assets/Images/Opponent/NoPlayer1.png"),
		"nocan": preload("res://src/Assets/Images/Opponent/NoPlayer2.png"),
		"noslippers": preload("res://src/Assets/Images/Opponent/NoPlayer3.png"),
		"notakyan": preload("res://src/Assets/Images/Opponent/NoPlayer4.png"),
		"noatis": preload("res://src/Assets/Images/Opponent/NoPlayer5.png")
	}

	# Get the client's ID
	var client_id: int = Client.client_id

	# Remove the client's ID from the token_symbols dictionary
	var opponent_tokens = Client.opponent_tokens.duplicate()
	
	print("TEST")
	print(opponent_tokens)
	
	opponent_tokens.erase(client_id)

	# List of opponent texture controls
	var opponent_controls = [opp1, opp2, opp3, opp4]

	# Track assigned textures to avoid conflicts
	var assigned_tokens: Array = []
	
	# Assign textures to opponents based on actual players
	var index = 0
	for player_id in opponent_tokens.keys():
		if index >= opponent_controls.size():
			break  # Ensure no out-of-bounds access
		var token_symbol = opponent_tokens[player_id]
		if token_textures.has(token_symbol):
			opponent_controls[index].texture.texture = token_textures[token_symbol]
			assigned_tokens.append(token_symbol)
			index += 1

	# Fill remaining opponent slots with "noplayer" textures
	var no_player_textures: Dictionary = {
		"marble": "nomarble",
		"can": "nocan",
		"slippers": "noslippers",
		"takyan": "notakyan",
		"atis": "noatis"
	}

	while index < opponent_controls.size():
		for token in no_player_textures.keys():
			if token in assigned_tokens:
				continue
			var no_token = no_player_textures[token]
			if token_textures.has(no_token):
				opponent_controls[index].texture.texture = token_textures[no_token]
				assigned_tokens.append(token)  # Mark as used
				index += 1
				break  # Exit inner loop once a texture is assigned
