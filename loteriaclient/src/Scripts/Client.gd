extends Node

const SERVER_ADDRESS: String = "127.0.0.1"
const SERVER_PORT: int = 33070

var my_info: Dictionary = {
	name = "Andrea",
	index = 0,
	instance = null
}

var player_info: Dictionary = {}

var is_creator: bool = false

var room: int
var timeout_timer: Timer = null
	
@rpc("any_peer")
func create_room(info: Dictionary) -> void:
	is_creator = true
	connect_to_server()

func connect_to_server(room_id: int = 0) -> void:
	room = room_id
	
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_client(SERVER_ADDRESS, SERVER_PORT) != OK:
		printerr("Error creating the client")
		return
	self.multiplayer.multiplayer_peer = peer
	
	get_tree().current_scene.start_timeout_timer()
	
	if self.multiplayer.connect("connected_to_server", Callable(self, "_connected_ok"), CONNECT_DEFERRED):
		printerr("Failed to connect connected_server")
	if self.multiplayer.connect("connection_failed", Callable(self, "_connected_fail"), CONNECT_DEFERRED):
		printerr("Failed to connect connection_failed")
	if self.multiplayer.connect("server_disconnected", Callable(self, "_server_disconnected"), CONNECT_DEFERRED):
		printerr("Failed to connect server_disconnected")
	
func stop() -> void:
	get_tree().current_scene.stop_timeout_timer()
	
	self.multiplayer.disconnect("connected_to_server", Callable(self, "_connected_ok"))
	self.multiplayer.disconnect("connection_failed", Callable(self, "_connected_fail"))
	self.multiplayer.disconnect("server_disconnected", Callable(self, "_server_disconnected"))
	self.multiplayer.multiplayer_peer = null
	_remove_all_players()
	
	if is_creator == false:
		if get_tree().current_scene.name == "Menu":
			var menu = get_tree().current_scene
			if menu.keep_join_dialog_open != true  && get_tree().current_scene.connect_button.text == "Connect" && get_tree().current_scene.error_label.text == "": 
				menu.toggle_buttons()
		
	is_creator = false

@rpc("any_peer")
func register_player(id: int, info: Dictionary) -> void:
	player_info[id] = info
	get_tree().current_scene.add_player_to_ui(info.name)

@rpc("any_peer")
func remove_player(id: int) -> void:
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.remove_player(player_info.keys().find(id))
	else:
		player_info[id].instance.queue_free()

	if not player_info.erase(id):
		printerr("Error removing player")

func _remove_all_players() -> void:
	
	if get_tree().current_scene.name == "Menu":
		get_tree().current_scene.remove_all_players()
	else:
		for player_id in player_info:
			player_info[player_id].instance.queue_free()
	
	player_info = {}

func _connected_ok() -> void:
	print("Connected to server!")
	get_tree().current_scene.stop_timeout_timer()
	if is_creator:
		rpc_id(1, "create_room", my_info)
	else:
		rpc_id(1, "join_room", room, my_info)

func _connected_fail() -> void:
	print("Failed connecting to the server!")
	get_tree().current_scene.show_server_dialog("Failed to connect to the server. Please try again.")
	
func _server_disconnected() -> void:
	print("Server disconnected!")
	stop()
	if get_tree().current_scene.name == "Menu":
		var menu = get_tree().current_scene
		menu.toggle_buttons()
	get_tree().current_scene.show_server_dialog("The server has disconnected.")
	
@rpc("any_peer")
func start_game() -> void:
	rpc_id(1, "start_game")

@rpc("any_peer")
func pre_configure_game() -> void:
	get_tree().current_scene.set_deferred("game_started", true)
	
	get_tree().paused = true
	
	get_tree().current_scene.queue_free()
	#var game: Node2D = preload("res://Game.tscn").instance()
	#get_tree().root.add_child(game)
	#get_tree().current_scene = game
	
	#var my_player: KinematicCollision2D = preload("res://characters/Player.tscn").instance()
	#game.add_child(my_player)
	#player_info[self.multiplayer.get_unique_id()].instance = my_player
	
	#for player_id in player_info:
		#if player_id != self.multiplayer.get_unique_id():
			#var player: KinematicCollision2D = preload("res://characters/BaseCharacter.tscn").instance()
			#game.add_child(player)
			#player_info[player_id].instance = player
			
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
	get_tree().current_scene.keep_join_dialog_open = true
	get_tree().current_scene.join_dialog.show_error(msg)

@rpc("any_peer")
func join_room(room_id: int, info: Dictionary) -> void:
	pass #dummy
