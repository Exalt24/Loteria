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
		state = GameState.WAITING
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
	rpc_id(id, "update_room", room_id)
	for player_id in rooms[room_id].players:
		rpc_id(player_id, "register_player", id, info)
	
	for other_player_id in rooms[room_id].players:
		if other_player_id != id:
			rpc_id(id, "register_player", other_player_id, rooms[room_id].players[other_player_id])
			
	var player_count = rooms[room_id].players.size()
	for player_id in rooms[room_id].players:
		rpc_id(player_id, "update_player_count", player_count)

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
		if not rooms.erase(room_id):
			printerr("Error removing room")
		empty_rooms.push_back(room_id)
		update_lobby_list_for_all_clients()
		return
	else:
		print("Notifying the other players in the room...")
	
		if rooms[room_id].creator == id:
			print("Creator left. Disconnecting all players in the room.")
			for player_id in rooms[room_id].players:
				if self.multiplayer.multiplayer_peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
					self.multiplayer.multiplayer_peer.disconnect_peer(player_id)
				else:
					print("Peer #", player_id, " is already disconnected.")
			rooms.erase(room_id)
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

func _get_room(player_id: int) -> Dictionary:
	return rooms[players_room[player_id]]

@rpc("any_peer")
func done_preconfiguring() -> void:
	var sender_id: int = self.multiplayer.get_remote_sender_id()
	
	var room: Dictionary = _get_room(sender_id)
	room.players_done += 1
	
	if room.players_done == room.players.size():
		for player_id in room.players:
			rpc_id(player_id, "done_preconfiguring")

func update_lobby_list_for_all_clients() -> void:
	var lobby_list: Array = []
	for room_id in rooms.keys():
		var room = rooms[room_id]
		if room.state != GameState.STARTED:  # Only include rooms not in "STARTED" state
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
