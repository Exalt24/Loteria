extends Node

const SERVER_PORT: int = 33070
const MAX_PLAYERS = 5
const ERROR_NONEXISTENT_ROOM: String = "Room does not exist."
const ERROR_GAME_ALREADY_STARTED: String = "Game has already started."
const ERROR_ROOM_IS_FULL: String = "The room is full. Maximum number of players is reached."

var rooms: Dictionary = {}
var players_room: Dictionary = {}
var next_room_id: int = 0
var empty_rooms: Array = []

enum GameState { WAITING, STARTED }

func _ready() -> void:
	
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	if peer.create_server(SERVER_PORT):
		printerr("Error creating the server")
		get_tree().quit()
		return
	self.multiplayer.multiplayer_peer = peer

	if self.multiplayer.connect("peer_connected", Callable(self, "_player_connected"), CONNECT_DEFERRED):
		printerr("Error connecting 'peer_connected' signal")
		get_tree().quit()

	if self.multiplayer.connect("peer_disconnected", Callable(self, "_player_disconnected"), CONNECT_DEFERRED):
		printerr("Error connecting 'peer_disconnected' signal")
		get_tree().quit()

@rpc("any_peer")
func create_room(info: Dictionary) -> void:
	print("Room created")
	var sender_id: int = self.multiplayer.get_remote_sender_id()
	
	var room_id: int
	if empty_rooms.size() == 0:
		room_id = next_room_id
		next_room_id += 1
	else:
		room_id = empty_rooms.pop_back()
	
	rooms[room_id] = {
		creator = sender_id,
		players = {},
		players_done = 0,
		state = GameState.WAITING,
		remaining_cards = [],
		timer = null,
		win_condition = 0
	}
	
	_add_player_to_room(room_id, sender_id, info)
	update_lobby_list_for_all_clients()

@rpc("any_peer")
func join_room(room_id: int, info: Dictionary) -> void:
	var sender_id: int = self.multiplayer.get_remote_sender_id()
	
	if info.size() >= MAX_PLAYERS:
		rpc_id(sender_id, "show_error", ERROR_ROOM_IS_FULL)
		return
	
	if not rooms.keys().has(room_id):
		print("Error: Room does not exist for player:", sender_id)
		rpc_id(sender_id, "show_error", ERROR_NONEXISTENT_ROOM)
		await get_tree().create_timer(1).timeout
		self.multiplayer.multiplayer_peer.disconnect_peer(sender_id)
	elif rooms[room_id].state == GameState.STARTED:
		print("Error: Game already started for room:", room_id)
		rpc_id(sender_id, "show_error", ERROR_GAME_ALREADY_STARTED)
		await get_tree().create_timer(1).timeout
		self.multiplayer.multiplayer_peer.disconnect_peer(sender_id)
	else:
		_add_player_to_room(room_id, sender_id, info)
		
	update_lobby_list_for_all_clients()

func _add_player_to_room(room_id: int, id: int, info: Dictionary) -> void:
	
	rooms[room_id].players[id] = info
	players_room[id] = room_id
	
	_update_player_tokens(room_id)
	
	rpc_id(id, "update_room", room_id)
	for player_id in rooms[room_id].players:
		rpc_id(player_id, "register_player", id, info)
	
	for other_player_id in rooms[room_id].players:
		if other_player_id != id:
			rpc_id(id, "register_player", other_player_id, rooms[room_id].players[other_player_id])
			
	var player_count = rooms[room_id].players.size()
	for player_id in rooms[room_id].players:
		rpc_id(player_id, "update_player_count", player_count)

func _update_player_tokens(room_id: int) -> void:
	var token_symbols = ["marble", "can", "slippers", "takyan", "atis"]

	print("Updating token symbols for room #", room_id)
	
	var index = 0
	for player_id in rooms[room_id].players.keys():
		var token = token_symbols[index % token_symbols.size()]
		rooms[room_id].players[player_id].token_symbol = token
		print("Player ID: ", player_id, " -> Token: ", token)
		index += 1

func _player_connected(id: int) -> void:
	print("Player #", id, " connected")
	
func _player_disconnected(id: int) -> void:
	print("Player #", id, " disconnected")
	
	if not players_room.keys().has(id):
		print("Player #", id, " was not in any room")
		return

	var room_id: int = players_room[id]
	
	if not rooms.has(room_id):
		print("Room #", room_id, " does not exist anymore.")
		return
		
	if not rooms[room_id].players.erase(id) or not players_room.erase(id):
		printerr("This key does not exist")
		
	if rooms[room_id].players.size() == 0:
		print("Closing room ", str(room_id))
		cleanup_room(room_id)
		empty_rooms.push_back(room_id)
		update_lobby_list_for_all_clients()
		return
	else:
		print("Notifying the other players in the room...")
		if rooms[room_id].state == GameState.WAITING:
			_update_player_tokens(room_id)
		
		if rooms[room_id].creator == id:
			print("Creator left. Disconnecting all players in the room.")
			for player_id in rooms[room_id].players:
				if self.multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
					self.multiplayer.multiplayer_peer.disconnect_peer(player_id)
				else:
					print("Peer #", player_id, " is already disconnected.")
			cleanup_room(room_id)
			empty_rooms.push_back(room_id)
			update_lobby_list_for_all_clients()
		else:
			for player_id in rooms[room_id].players:
				if self.multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
					rpc_id(player_id, "remove_player", id)
				else:
					print("Peer #", player_id, " is not connected; skipping notification.")

			var player_count = rooms[room_id].players.size()
			for player_id in rooms[room_id].players:
				if self.multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
					rpc_id(player_id, "update_player_count", player_count)
				else:
					print("Peer #", player_id, " is not connected; skipping player count update.")
			
			update_lobby_list_for_all_clients()

@rpc("any_peer")
func start_game() -> void:
	var sender_id: int = self.multiplayer.get_remote_sender_id()
	var room: Dictionary = _get_room(sender_id)
	
	room.state = GameState.STARTED
	
	for player_id in room.players:
		rpc_id(player_id, "pre_configure_game")

	update_lobby_list_for_all_clients()
	
	handle_in_game(room)

func handle_in_game(room: Dictionary) -> void:
	# Validate room state
	if room == null:
		printerr("Room does not exist.")
		return

	if room.state != GameState.STARTED:
		printerr("Game is not in progress for room.")
		return

	# Initialize the card set for the room as integer indices
	room.remaining_cards = range(0, 44)
	room.remaining_cards.shuffle()
	
	# Set the win condition for the room
	var win_condition = randi_range(0, 3)
	room["win_condition"] = win_condition
	print("Room ID: ", room.creator, " - Win condition set to: ", win_condition)


	for player_id in room.players:
		rpc_id(player_id, "set_win_condition", win_condition)

	# Create and configure a timer for this room
	var timer = Timer.new()
	add_child(timer)  # Add it as a child to manage its lifecycle
	timer.wait_time = 3.0
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_call_next_card").bind(room))
	timer.start()

	room.timer = timer

	print("Game started for room. Cards shuffled, win condition set, and timer initialized.")

func _call_next_card(room: Dictionary) -> void:
	if room.remaining_cards.size() > 0:
		var called_card = room.remaining_cards.pop_front()
		print("Room ID: ", room.creator, " - Called card index: ", called_card)

		# Notify all players in the room
		for player_id in room.players:
			rpc_id(player_id, "show_called_card", called_card)
			
		for player_id in room.players:
			rpc_id(player_id, "reset_timer_from_server")
	else:
		# Stop the timer when all cards are called
		if room.timer:
			room.timer.stop()
			room.timer.queue_free()
			room.timer = null
		print("All cards have been called for room ID: ", room.creator)
		end_game(room)

func end_game(room: Dictionary) -> void:
	# Notify all players that the game has ended
	for player_id in room.players:
		rpc_id(player_id, "game_ended")
	
	# Clear room-related data
	var room_id: int = room.creator
	cleanup_room(room_id)

func _get_room(player_id: int) -> Dictionary:
	return rooms[players_room[player_id]]

@rpc("any_peer")
func done_preconfiguring() -> void:
	var sender_id: int = self.multiplayer.get_remote_sender_id()
	
	var room: Dictionary = _get_room(sender_id)
	var win_condition = randi_range(0, 3)
	
	room.players_done += 1
	
	if room.players_done == room.players.size():
		for player_id in room.players:
			rpc_id(player_id, "done_preconfiguring")

func update_lobby_list_for_all_clients() -> void:
	var lobby_list: Array = []
	for room_id in rooms.keys():
		var room = rooms[room_id]
		if room.state != GameState.STARTED:
			lobby_list.append({
				"room_id": room_id,
				"creator": room.creator,
				"player_count": room.players.size(),
				"state": room.state
			})
	rpc("receive_lobby_list", lobby_list)


@rpc("any_peer")
func request_lobby_list() -> void:
	var sender_id: int = self.multiplayer.get_remote_sender_id()
	var lobby_list: Array = []
	for room_id in rooms.keys():
		var room = rooms[room_id]
		lobby_list.append({
			"room_id": room_id,
			"creator": room.creator,
			"player_count": room.players.size(),
			"state": room.state
		})
	rpc_id(sender_id, "receive_lobby_list", lobby_list)

func cleanup_room(room_id: int) -> void:
	if not rooms.has(room_id):
		printerr("Room ID: ", room_id, " does not exist.")
		return

	var room = rooms[room_id]

	# Stop and free the timer if it exists
	if room.timer:
		room.timer.stop()
		room.timer.queue_free()

	if not rooms.erase(room_id):
		printerr("Error removing room")
	print("Room ID: ", room_id, " has been cleaned up.")

@rpc("any_peer")
func reset_timer_from_server() -> void:
	pass #dummy

@rpc("any_peer")
func update_room(room_id: int) -> void:
	pass #dummy

@rpc("any_peer")
func register_player(id: int, info: Dictionary) -> void:
	pass #dummy
	
@rpc("any_peer")
func remove_player(id: int) -> void:
	pass #dummy

@rpc("any_peer")
func update_player_count(player_count: int) -> void:
	pass #dummy

@rpc("any_peer")
func pre_configure_game() -> void:
	pass #dummy

@rpc("any_peer")
func show_error(msg: String) -> void:
	pass #dummy

@rpc("any_peer")
func receive_lobby_list(lobby_list: Array) -> void:
	pass #dummy
	
@rpc("any_peer")
func show_called_card(called_card_index: int) -> void:
	pass #dummy

@rpc("any_peer")
func set_win_condition(win_condition: int) -> void:
	pass #dummy
	
@rpc("any_peer")
func game_ended() -> void:
	pass #dummy	
