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
@onready var coin_texture = preload("res://src/Assets/Images/coin.png")

@onready var audio_player: AudioStreamPlayer2D = $bgm

func _ready() -> void:
	if audio_player:
		audio_player.stream = background_music
		audio_player.volume_db = -3.0
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

	var client_id: int = Client.client_id
	var client_token: String = Client.opponent_tokens[client_id] 
	var opponent_tokens = Client.opponent_tokens.duplicate()
	opponent_tokens.erase(client_id)

	# List of opponent texture controls
	var opponent_controls = [opp1, opp2, opp3, opp4]

	# Track assigned textures to avoid conflicts
	var assigned_tokens: Array = [client_token]
	# Assign textures to opponents based on actual players
	var index = 0
	for player_id in opponent_tokens.keys():
		if index >= opponent_controls.size():
			break  # Ensure no out-of-bounds access
		var token_symbol = opponent_tokens[player_id]
		if token_textures.has(token_symbol):
			opponent_controls[index].texture.texture = token_textures[token_symbol]
			assigned_tokens.append(token_symbol)
			opponent_controls[index].current_token = token_symbol
			opponent_controls[index].current_player = player_id 
			index += 1

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

func update_opponents_progress() -> void:
	var token_textures: Dictionary = {
		"marble": preload("res://src/Assets/Images/Articles/bola.png"),
		"can": preload("res://src/Assets/Images/Articles/lata.png"),
		"slippers": preload("res://src/Assets/Images/Articles/tsinelas.png"),
		"takyan": preload("res://src/Assets/Images/Articles/takyan.png"),
		"atis": preload("res://src/Assets/Images/Articles/prutas.png"),
	}

	var client_id: int = Client.client_id
	var client_token: String = Client.opponent_tokens[client_id]
	var opponent_tokens = Client.opponent_tokens.duplicate()
	var opponent_matrices = Client.opponent_matrices.duplicate()

	# Remove the client's token and matrix from opponents
	opponent_tokens.erase(client_id)
	opponent_matrices.erase(client_id)

	var opponent_controls = [opp1, opp2, opp3, opp4]
	
	# Iterate over opponent controls
	for opponent_control in opponent_controls:
		var control_token = opponent_control.current_token  # Assume this control has a way to store its token
		
		if control_token in opponent_tokens.values():
			var player_id = opponent_tokens.keys()[opponent_tokens.values().find(control_token)]
			var token_symbol = opponent_tokens[player_id]
			var player_matrix = opponent_matrices[player_id]

			# Ensure the control matches the current control's token
			if control_token == opponent_control.current_token and token_textures.has(token_symbol):
				# Get the valid slots for this control
				var slots = []
				for child in opponent_control.get_children():
					if child is Panel:
						slots.append(child)

				# Update the progress based on the player's matrix
				for card_index in range(slots.size()):
					var row = card_index / 4
					var col = card_index % 4

					if row < player_matrix.size() and col < player_matrix[row].size():
						if player_matrix[row][col] == 1:
							var slot = slots[card_index]
							if slot is Panel:
								var texture_display = TextureRect.new()
								texture_display.texture = token_textures[token_symbol]

								var panel_size = slot.get_rect().size
								var original_size = texture_display.texture.get_size()
								var scale_factor = panel_size / original_size / 2
								texture_display.scale = scale_factor
								texture_display.position = panel_size / 2 - (original_size * scale_factor) / 2

								slot.add_child(texture_display)
