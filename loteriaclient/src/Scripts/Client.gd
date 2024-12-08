extends Node

var SERVER_ADDRESS: String = ""
const SERVER_PORT: int = 33070


@export var loterya_cards: Array = [
	preload("res://src/Assets/Images/Loterya Cards/Agila.png"),
	preload("res://src/Assets/Images/Loterya Cards/Anahaw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Arnis.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bahay Kubo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bakya.png"),
	preload("res://src/Assets/Images/Loterya Cards/Balut.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bangus.png"),
	preload("res://src/Assets/Images/Loterya Cards/Banig.png"),
	preload("res://src/Assets/Images/Loterya Cards/Baro.png"),
	preload("res://src/Assets/Images/Loterya Cards/Barong.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bayanihan.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bolo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Buko.png"),
	preload("res://src/Assets/Images/Loterya Cards/Bulalo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Duwende.png"),
	preload("res://src/Assets/Images/Loterya Cards/Halo-Halo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Harana.png"),
	preload("res://src/Assets/Images/Loterya Cards/Isaw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Jeepney.png"),
	preload("res://src/Assets/Images/Loterya Cards/Kalesa.png"),
	preload("res://src/Assets/Images/Loterya Cards/Kulintang.png"),
	preload("res://src/Assets/Images/Loterya Cards/Lechon.png"),
	preload("res://src/Assets/Images/Loterya Cards/Mangga.png"),
	preload("res://src/Assets/Images/Loterya Cards/Maskara.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pagmamano.png"),
	preload("res://src/Assets/Images/Loterya Cards/Palay.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pamaypay.png"),
	preload("res://src/Assets/Images/Loterya Cards/Pandesal.png"),
	preload("res://src/Assets/Images/Loterya Cards/Parol.png"),
	preload("res://src/Assets/Images/Loterya Cards/Piyesta.png"),
	preload("res://src/Assets/Images/Loterya Cards/Puso.png"),
	preload("res://src/Assets/Images/Loterya Cards/Puto.png"),
	preload("res://src/Assets/Images/Loterya Cards/Rice Terraces.png"),
	preload("res://src/Assets/Images/Loterya Cards/Salakot.png"),
	preload("res://src/Assets/Images/Loterya Cards/Sampaguita.png"),
	preload("res://src/Assets/Images/Loterya Cards/Sungka.png"),
	preload("res://src/Assets/Images/Loterya Cards/Taho.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tamaraw.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tarsier.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tindahan.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tinikling.png"),
	preload("res://src/Assets/Images/Loterya Cards/Tumbang Preso.png"),
	preload("res://src/Assets/Images/Loterya Cards/Vinta.png"),
	preload("res://src/Assets/Images/Loterya Cards/Walis Tambo.png"),
	preload("res://src/Assets/Images/Loterya Cards/Watawat.png")
]

var my_info: Dictionary = {
	name = "Carl",
	instance = null,
	token_symbol = null,
	matrix = [
				[0, 0, 0, 0],
				[0, 0, 0, 0],
				[0, 0, 0, 0],
				[0, 0, 0, 0]
			]
}

var player_info: Dictionary = {}

var is_creator: bool = false
var is_fetching: bool = false
var the_winner_id: int = -1
var room: int
var win_condition: int
var opponent_tokens: Dictionary = {}
var opponent_matrices: Dictionary = {}
var win_patterns: Array = [
	# Column win patterns (Variations of columns)
	[
		# Column 1
		[
			[1, 0, 0, 0],
			[1, 0, 0, 0],
			[1, 0, 0, 0],
			[1, 0, 0, 0]
		],
		# Column 2
		[
			[0, 1, 0, 0],
			[0, 1, 0, 0],
			[0, 1, 0, 0],
			[0, 1, 0, 0]
		],
		# Column 3
		[
			[0, 0, 1, 0],
			[0, 0, 1, 0],
			[0, 0, 1, 0],
			[0, 0, 1, 0]
		],
		# Column 4
		[
			[0, 0, 0, 1],
			[0, 0, 0, 1],
			[0, 0, 0, 1],
			[0, 0, 0, 1]
		]
	],
	# Row win patterns (Variations of rows)
	[
		# Row 1
		[
			[1, 1, 1, 1],
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0]
		],
		# Row 2
		[
			[0, 0, 0, 0],
			[1, 1, 1, 1],
			[0, 0, 0, 0],
			[0, 0, 0, 0]
		],
		# Row 3
		[
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[1, 1, 1, 1],
			[0, 0, 0, 0]
		],
		# Row 4
		[
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[1, 1, 1, 1]
		]
	],
	# Cube win patterns (Variations of cubes)
	[
		# Cube 1
		[
			[1, 1, 0, 0],
			[1, 1, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0]
		],
		# Cube 2
		[
			[0, 1, 1, 0],
			[0, 1, 1, 0],
			[0, 0, 0, 0],
			[0, 0, 0, 0]
		],
		# Cube 3
		[
			[0, 0, 1, 1],
			[0, 0, 1, 1],
			[0, 0, 0, 0],
			[0, 0, 0, 0]
		],
		# Cube 4
		[
			[0, 0, 0, 0],
			[1, 1, 0, 0],
			[1, 1, 0, 0],
			[0, 0, 0, 0]
		],
		# Cube 5
		[
			[0, 0, 0, 0],
			[0, 1, 1, 0],
			[0, 1, 1, 0],
			[0, 0, 0, 0]
		],
		# Cube 6
		[
			[0, 0, 0, 0],
			[0, 0, 1, 1],
			[0, 0, 1, 1],
			[0, 0, 0, 0]
		],
		# Cube 7
		[
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[1, 1, 0, 0],
			[1, 1, 0, 0]
		],
		# Cube 8
		[
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 1, 1, 0],
			[0, 1, 1, 0]
		],
		# Cube 9
		[
			[0, 0, 0, 0],
			[0, 0, 0, 0],
			[0, 0, 1, 1],
			[0, 0, 1, 1]
		]	
	],
	# Cross win patterns (Variations of Cross)
	[
		# Cross 1
		[
			[0, 1, 0, 0],
			[1, 1, 1, 0],
			[0, 1, 0, 0],
			[0, 0, 0, 0]
		],
		# Cross 2
		[
			[0, 0, 1, 0],
			[0, 1, 1, 1],
			[0, 0, 1, 0],
			[0, 0, 0, 0]
		],
		# Cross 3
		[
			[0, 0, 0, 0],
			[0, 1, 0, 0],
			[1, 1, 1, 0],
			[0, 1, 0, 0]
		],
		# Cross 4
		[
			[0, 0, 0, 0],
			[0, 0, 1, 0],
			[0, 1, 1, 1],
			[0, 0, 1, 0]
		]
	]
]

var current_win_pattern: Array 
var client_id: int

@rpc("any_peer")
func create_room(info: Dictionary) -> void:
	is_creator = true
	connect_to_server()

func connect_to_server(room_id: int = 0) -> void:
	room = room_id
	
	 # Start listening for the broadcast packet (we will block the code until we get the IP)
	print("Waiting for server IP to be discovered...")

	# Initialize the UDP network for receiving the broadcast message
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var udp_network = PacketPeerUDP.new()

	# Wait until the server IP is discovered
	await wait_for_server_ip(udp_network)
	
	if SERVER_ADDRESS != "":
		print("Connecting to server at: ", SERVER_ADDRESS)
		if peer.create_client(SERVER_ADDRESS, SERVER_PORT) != OK:
			printerr("Error creating the client")
			return
		self.multiplayer.multiplayer_peer = peer
	
		if self.multiplayer.is_connected("connected_to_server", Callable(self, "_connected_ok")):
			self.multiplayer.disconnect("connected_to_server", Callable(self, "_connected_ok"))
		if self.multiplayer.is_connected("connection_failed", Callable(self, "_connected_fail")):
			self.multiplayer.disconnect("connection_failed", Callable(self, "_connected_fail"))
		if self.multiplayer.is_connected("server_disconnected", Callable(self, "_server_disconnected")):
			self.multiplayer.disconnect("server_disconnected", Callable(self, "_server_disconnected"))

		self.multiplayer.connect("connected_to_server", Callable(self, "_connected_ok"), CONNECT_DEFERRED)
		self.multiplayer.connect("connection_failed", Callable(self, "_connected_fail"), CONNECT_DEFERRED)
		self.multiplayer.connect("server_disconnected", Callable(self, "_server_disconnected"), CONNECT_DEFERRED)

func wait_for_server_ip(udp_network: PacketPeerUDP) -> void:
	var base_port = 33071  # Starting port number for binding
	var max_retries = 20  # Limit the number of retries (e.g., 20 ports)
	var bind_result = ERR_BUSY  # Initialize with a value that ensures we try binding

	print("Listening for server broadcasts...")

	# Try binding to ports sequentially until one succeeds
	for port_offset in range(max_retries):
		var current_port = base_port + port_offset  # Increment the port number by 1 each time
		
		bind_result = udp_network.bind(current_port)
		
		if bind_result == OK:
			print("Bound to port %d successfully." % current_port)
			break  # Exit the loop when a successful bind occurs
		else:
			print("Failed to bind UDP socket to port %d" % current_port)
		
		# If we tried all ports and failed, print an error and exit
		if port_offset == max_retries - 1:
			printerr("Error: Unable to bind to any UDP port after %d retries." % max_retries)
			return  # Exit the function if all retries failed

	udp_network.set_broadcast_enabled(true)  # Enable broadcasting

	# Wait until the IP address is discovered
	while SERVER_ADDRESS == "":
		if udp_network.get_available_packet_count() > 0:
			var packet = udp_network.get_packet()  # Get the incoming packet
			SERVER_ADDRESS = udp_network.get_packet_ip()  # Extract the IP from the packet
			print("Found server at: %s" % SERVER_ADDRESS)
			break  # Exit the loop once the IP is found
		
		await get_tree().create_timer(0.0).timeout  # Wait for the next frame

func stop() -> void:
	SERVER_ADDRESS = ""
	if self.multiplayer.is_connected("connected_to_server", Callable(self, "_connected_ok")):
		self.multiplayer.disconnect("connected_to_server", Callable(self, "_connected_ok"))
	if self.multiplayer.is_connected("connection_failed", Callable(self, "_connected_fail")):
		self.multiplayer.disconnect("connection_failed", Callable(self, "_connected_fail"))
	if self.multiplayer.is_connected("server_disconnected", Callable(self, "_server_disconnected")):
		self.multiplayer.disconnect("server_disconnected", Callable(self, "_server_disconnected"))
	self.multiplayer.multiplayer_peer = null
	_remove_all_players()
	
	if is_creator == false:
		if get_tree().current_scene.name == "Menu":
			var menu = get_tree().current_scene
			menu.toggle_buttons()
			menu.waiting_host_label.text = ""
		
	is_creator = false
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.create_dialog_label.text = "Creating room..."

func stops() -> void:
	SERVER_ADDRESS = ""
	if self.multiplayer.is_connected("connected_to_server", Callable(self, "_connected_ok")):
		self.multiplayer.disconnect("connected_to_server", Callable(self, "_connected_ok"))
	if self.multiplayer.is_connected("connection_failed", Callable(self, "_connected_fail")):
		self.multiplayer.disconnect("connection_failed", Callable(self, "_connected_fail"))
	if self.multiplayer.is_connected("server_disconnected", Callable(self, "_server_disconnected")):
		self.multiplayer.disconnect("server_disconnected", Callable(self, "_server_disconnected"))
	self.multiplayer.multiplayer_peer = null
	_remove_all_players()
	
	if get_tree().current_scene.name == "Menu":
		var menu = get_tree().current_scene
		menu.waiting_host_label.text = ""
		get_tree().current_scene.create_dialog_label.text = "Creating room..."
		
func fin_stop() -> void:
	SERVER_ADDRESS = ""
	if self.multiplayer.is_connected("connected_to_server", Callable(self, "_connected_ok")):
		self.multiplayer.disconnect("connected_to_server", Callable(self, "_connected_ok"))
	if self.multiplayer.is_connected("connection_failed", Callable(self, "_connected_fail")):
		self.multiplayer.disconnect("connection_failed", Callable(self, "_connected_fail"))
	if self.multiplayer.is_connected("server_disconnected", Callable(self, "_server_disconnected")):
		self.multiplayer.disconnect("server_disconnected", Callable(self, "_server_disconnected"))
	self.multiplayer.multiplayer_peer = null
	_remove_all_players()
	
	if is_creator == false:
		if get_tree().current_scene.name == "Menu":
			var menu = get_tree().current_scene
			menu.waiting_host_label.text = ""
	
	is_creator = false
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.create_dialog_label.text = "Creating room..."

@rpc("any_peer")
func register_player(id: int, info: Dictionary) -> void:
	player_info[id] = info
	get_tree().current_scene.add_player_to_ui(info.name)

@rpc("any_peer")
func remove_player(id: int) -> void:
	# Check if we are in the menu or the game scene
	if get_tree().current_scene.name == "Menu":
		show_server_label("Player # %d has disconnected" % id)  # Show disconnection message with player ID
		if get_tree().current_scene.has_method("remove_player"):
			get_tree().current_scene.remove_player(player_info.keys().find(id))
		else:
			print("Warning: remove_player method not found in Menu scene.")
	elif get_tree().current_scene.name == "GameUI":
		show_server_label("Player # %d has disconnected" % id)
		get_tree().current_scene.disconnect_opponent(id)
		if id in player_info and player_info[id].instance:
			player_info[id].instance.queue_free()
			print("Player instance removed for player ID:", id)
		else:
			print("Warning: player_info[", id, "] instance is null or does not exist.")
	else:
		show_server_label("Player # %d has disconnected" % id)  # Show disconnection message with player ID
		if id in player_info and player_info[id].instance:
			player_info[id].instance.queue_free()
			print("Player instance removed for player ID:", id)
		else:
			print("Warning: player_info[", id, "] instance is null or does not exist.")

	# Synchronize the removal in player_info
	if player_info.erase(id):
		print("Player ID: ", id, " successfully removed from player_info.")
	else:
		print("Error removing player ID:", id, "from player_info.")

# Function to show the server label with the message and hide it after 3 seconds
func show_server_label(message: String) -> void:
	var scene = get_tree().current_scene
	var label = scene.server_label  # Access the server label
	label.text = message  # Set the text of the label
	label.visible = true  # Make the label visible

	# Start a timer to hide the label after 3 seconds
	var timer = Timer.new()
	scene.add_child(timer)  # Add the timer to the scene
	timer.wait_time = 3.0  # Wait for 3 seconds
	timer.one_shot = true  # Only trigger once
	timer.connect("timeout", Callable(self, "_hide_server_label").bind(label))  # Hide label when timer finishes
	timer.start()  # Start the timer

func _hide_server_label(label: Label) -> void:
	label.visible = false  # Hide the label after the timer completes

func _remove_all_players() -> void:
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.remove_all_players()
	else:
		for player_id in player_info:
			if player_info[player_id].instance:
				player_info[player_id].instance.queue_free()
			else:
				print("Warning: player_info[", player_id, "] instance is null.")

	player_info = {}

func _connected_ok() -> void:
	client_id = self.multiplayer.multiplayer_peer.get_unique_id()
	
	if is_creator:
		rpc_id(1, "create_room", my_info)
		
	elif is_fetching:
		rpc_id(1, "request_lobby_list")
		is_fetching = false
	else:
		rpc_id(1, "join_room", room, my_info)

func _connected_fail() -> void:
	SERVER_ADDRESS = ""
	print("Failed connecting to the server!")
	if is_creator == true:
		stop()
	else:
		stops()
	get_tree().current_scene.show_server_dialog("Failed to connect to the server. Please try again.")
	
func _server_disconnected() -> void:
	print("Server disconnected!")
	SERVER_ADDRESS = ""
	if get_tree().current_scene.name != "Menu":
		_change_to_main_menu()
	
	stop()
	
	get_tree().current_scene._set_buttons_state(true)
	var dialog = get_tree().current_scene.show_server_dialog("The server has disconnected.")
	if dialog:
		dialog.connect("confirmed", self, "_on_server_dialog_confirmed")
	
func _change_to_main_menu():
	# Safely queue_free the current scene
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	# Load and instantiate the main menu scene
	var main_menu = preload("res://src/Scenes/Menu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	get_tree().current_scene = main_menu

	print("Changed to main menu.")


@rpc("any_peer")
func start_game() -> void:
	rpc_id(1, "start_game")

@rpc("any_peer")
func pre_configure_game() -> void:
	get_tree().current_scene.set_deferred("game_started", true)
	
	get_tree().paused = false

	# Free the current scene
	get_tree().current_scene.queue_free()

	# Load and display GoalPattern.tscn first
	var goal_pattern_scene: Control = preload("res://src/Scenes/GoalPattern.tscn").instantiate()
	get_tree().root.add_child(goal_pattern_scene)
	get_tree().current_scene = goal_pattern_scene
	
	# Await a timer to introduce a delay
	await get_tree().create_timer(3.0).timeout  # Adjust the timer duration as needed

	get_tree().paused = true
	# Load and display main_game_ui.tscn
	var game: Control = preload("res://src/Scenes/main_game_ui.tscn").instantiate()
	get_tree().root.add_child(game)
	get_tree().current_scene = game
	
	rpc_id(1, "done_preconfiguring")

		
@rpc("any_peer")
func update_player_count(player_count: int) -> void:
	if get_tree().current_scene.name == "Menu":
		var menu = get_tree().current_scene
		menu.update_player_count(player_count)

@rpc("any_peer")
func update_room(room_id: int) -> void:
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.update_room(room_id)

@rpc("any_peer")
func done_preconfiguring() -> void:
	get_tree().paused = false

@rpc("any_peer")
func show_error(msg: String) -> void:
	get_tree().current_scene.show_server_dialog(msg)

@rpc("any_peer")
func receive_lobby_list(lobby_list: Array) -> void:
	print(lobby_list)
	
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.update_lobby_list(lobby_list)

@rpc("any_peer")
func show_called_card(called_card_index: int) -> void:

	if get_tree().current_scene.name == "GameUI":
		var called_card_texture = loterya_cards[called_card_index]
		var current_scene = get_tree().current_scene
		current_scene.caller_display.texture = called_card_texture
		current_scene.nine_patch_rect.update_caller_card(called_card_index)

@rpc("any_peer")
func set_win_condition(condition: int) -> void:
	win_condition = condition
	
	match win_condition:
		0:
			print("Selected Column Win Pattern")
			current_win_pattern = win_patterns[0]
		1:
			print("Selected Row Win Pattern")
			current_win_pattern = win_patterns[1]
		2:
			print("Selected Cube Win Pattern")
			current_win_pattern = win_patterns[2]
		3:
			print("Selected Cross Win Pattern")
			current_win_pattern = win_patterns[3]
		_:
			print("Invalid win condition received!")
			
@rpc("any_peer")
func set_opponent_tokens(tokens: Dictionary) -> void:
	opponent_tokens = tokens

func check_for_pattern_match(matrix: Array) -> void:
	match win_condition:
		0:
			for column_pattern in current_win_pattern:
				if check_partial_match(matrix, column_pattern):
					print("Column win detected!")
					get_tree().current_scene.loterya_button.disabled = false
					return
		1:
			for row_pattern in current_win_pattern:
				if check_partial_match(matrix, row_pattern):
					print("Row win detected!")
					get_tree().current_scene.loterya_button.disabled = false
					return
		2:
			for cube_pattern in current_win_pattern:
				if check_partial_match(matrix, cube_pattern):
					print("Cube win detected!")
					get_tree().current_scene.loterya_button.disabled = false
					return
		
		3:
			for cross_pattern in current_win_pattern:
				if check_partial_match(matrix, cross_pattern):
					print("Cross win detected!")
					get_tree().current_scene.loterya_button.disabled = false
					return
		
		_:
			print("Invalid win condition selected!")
	
	# If no match was found
	print("No match found for current pattern.")

func check_partial_match(matrix: Array, pattern: Array) -> bool:
	for row in range(4):
		for col in range(4):
			if pattern[row][col] == 1 and matrix[row][col] != 1:
				return false
	return true

@rpc("any_peer")
func winner_game() -> void:
	rpc_id(1, "declare_winner", room)

@rpc("any_peer")
func game_ended() -> void:
	print("Game has ended abruptly.")
	
	# Clean up the current scene and transition to the results or menu
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	# Load the main menu or results screen
	var menu = preload("res://src/Scenes/Menu.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene = menu
	
	fin_stop()

@rpc("any_peer")
func reset_timer_from_server() -> void:

	if get_tree().current_scene.name == "GameUI":
		var current_scene = get_tree().current_scene
		current_scene.time_bar.reset_timer()

@rpc("any_peer")
func declare_winner(winner_id: int) -> void:
	var my_id: int = self.multiplayer.get_unique_id()
	the_winner_id = winner_id
	
	if is_creator:
		await get_tree().create_timer(1.0).timeout
		fin_stop()
	else:
		fin_stop()
	
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	if winner_id == -1:
		var results = preload("res://src/Scenes/NoWinner.tscn").instantiate()
		get_tree().root.add_child(results)
		get_tree().current_scene = results
	elif winner_id == my_id:
		var results = preload("res://src/Scenes/Win.tscn").instantiate()
		get_tree().root.add_child(results)
		get_tree().current_scene = results
	else:
		var results = preload("res://src/Scenes/Lose.tscn").instantiate()
		get_tree().root.add_child(results)
		get_tree().current_scene = results

@rpc("any_peer")
func send_matrix_to_server(matrix: Array) -> void:
	rpc_id(1, "update_matrix_in_server", room, matrix)

@rpc("any_peer")
func update_opponent_matrices(matrices: Dictionary) -> void:
	opponent_matrices = matrices
	if get_tree().current_scene.name == "GameUI":
		get_tree().current_scene.update_opponents_progress()

@rpc("any_peer")
func request_lobby_list() -> void:
	pass #dummy

@rpc("any_peer")
func join_room(room_id: int, info: Dictionary) -> void:
	pass #dummy
	
@rpc("any_peer")
func update_matrix_in_server(room_id: int, matrix: Array) -> void:
	pass #dummy
