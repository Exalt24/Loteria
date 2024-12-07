extends Control

static var is_first_boot: bool = true
var game_started: bool = false

@onready var create_dialog: Panel = $Background/DialogContainer/CreateDialog
@onready var create_dialog_label: Label = $Background/DialogContainer/CreateDialog/VBoxContainer/VBoxContainer/MarginContainer/LabelContainer/Label
@onready var join_dialog: Panel = $Background/DialogContainer/JoinDialog
@onready var join_dialog_label: Label = $Background/DialogContainer/JoinDialog/VBoxContainer/MarginContainer/LabelContainer/Label
@onready var create_server_button: Button = $Background/ButtonContainer/CreateServerButton
@onready var join_server_button: Button = $Background/ButtonContainer/JoinServerButton
@onready var change_name_button: Button = $Background/ButtonContainer/ChangeNameButton
@onready var connect_v_box_container: VBoxContainer = $Background/SelectRoomDialog/MarginContainer/VBoxContainer/ScrollContainer/ConnectVBoxContainer
@onready var start_button: Button = $Background/DialogContainer/CreateDialog/Start
@onready var server_dialog: PanelContainer = $Background/ServerDialog
@onready var server_dialog_text: Label = $Background/ServerDialog/MarginContainer/VBoxContainer/Label
@onready var change_name_dialog: Panel = $Background/DialogContainer/ChangeNameDialog
@onready var edit_name: LineEdit = $Background/DialogContainer/ChangeNameDialog/MarginContainer/VBoxContainer/EditName
@onready var name_label: Label = $Background/MarginContainer/VBoxContainer/NameContainer/NameLabel
@onready var change_button: Button = $Background/DialogContainer/ChangeNameDialog/MarginContainer/VBoxContainer/HBoxContainer/Change
@onready var lobby_list_container: VBoxContainer = $Background/SelectRoomDialog/MarginContainer/VBoxContainer/ScrollContainer/ConnectVBoxContainer/LobbyList
@onready var loading_label: Label = $Background/SelectRoomDialog/MarginContainer/VBoxContainer/ScrollContainer/ConnectVBoxContainer/Label
@onready var transparent_container: ColorRect = $Background/TransparentContainer
@onready var button_container: VBoxContainer = $Background/ButtonContainer
@onready var waiting_host_label: Label = $Background/WaitingHostLabel
@onready var select_room_dialog: Panel = $Background/SelectRoomDialog
@onready var name_margin_container: MarginContainer = $Background/MarginContainer
const THEME = preload("res://src/Assets/Theme.tres")

@export var intro_sfx = preload("res://src/Assets/Sounds/BGM/[1]intro.wav")
@export var menu_sfx = preload("res://src/Assets/Sounds/BGM/[2]menu.wav")
@export var button_sfx = preload("res://src/Assets/Sounds/BGM/[8]button.wav")

@onready var intro: AudioStreamPlayer2D = $intro
@onready var menu: AudioStreamPlayer2D = $menu_bgm
@onready var button: AudioStreamPlayer2D = $button


@onready var player_textures: Array = [
	preload("res://src/Assets/Images/Lobby/creating_lobby.png"),
	preload("res://src/Assets/Images/Lobby/one_player_lobby.png"),
	preload("res://src/Assets/Images/Lobby/two_player_lobby.png"),
	preload("res://src/Assets/Images/Lobby/three_player_lobby.png"),
	preload("res://src/Assets/Images/Lobby/four_player_lobby.png"),
	preload("res://src/Assets/Images/Lobby/five_player_lobby.png"),
]

func _ready() -> void:
	if is_first_boot:
		is_first_boot = false
		show_welcome_screen()
	else:
		setup_main_menu()

func show_welcome_screen() -> void:
	# Load and instantiate the WelcomePage.tscn
	var welcome_page = preload("res://src/Scenes/WelcomePage.tscn").instantiate()
	
	if intro:
		intro.stream = intro_sfx
		intro.play()
	
	# Add the welcome page deferred to avoid setup conflict
	get_tree().root.call_deferred("add_child", welcome_page)
	
	# Hide the current scene elements temporarily
	visible = false

	# Wait asynchronously for a few seconds
	await get_tree().create_timer(8.0).timeout  # Adjust duration as needed
	
	# Remove the welcome page
	welcome_page.queue_free()

	# Show the current scene elements
	visible = true

	# Continue with the rest of the setup
	setup_main_menu()


func setup_main_menu() -> void:
	if menu:
		menu.stream = menu_sfx
		menu.play()
	
	# Example of what happens after the welcome screen
	THEME.set_type_variation("SelectServerButton", "Button")
	start_button.disabled = true
	name_label.text = "Mabuhay!"

func update_room(room_id: int) -> void:
	if Client.is_creator:
		create_dialog_label.text = "Room ID: " + str(room_id)
	else:
		join_dialog_label.text = "Room ID: " + str(room_id)
		join_dialog.connected_ok()

func _on_create_server_button_pressed() -> void:
	play_button_sfx()
	server_dialog.hide()
	Client.create_room({})
	Helper.center_panel(create_dialog)
	create_dialog.show()
	toggle_buttons()

func _on_create_dialog_back_pressed() -> void:
	play_button_sfx()
	server_dialog.hide()
	create_dialog.hide()
	if self.multiplayer.multiplayer_peer != null:
		Client.stop()
	toggle_buttons()

func _on_join_server_button_pressed() -> void:
	play_button_sfx()
	server_dialog.hide()
	Client.is_fetching = true
	Client.connect_to_server()
	select_room_dialog.show()
	loading_label.show()
	toggle_buttons()

func _on_join_dialog_back_pressed() -> void:
	play_button_sfx()
	server_dialog.hide()
	waiting_host_label.text = ""
	join_dialog.hide()
	if self.multiplayer.multiplayer_peer != null:
		Client.stop()
	else:
		toggle_buttons()
	

func _on_select_room_dialog_back_pressed() -> void:
	play_button_sfx()
	server_dialog.hide()
	select_room_dialog.hide()
	if self.multiplayer.multiplayer_peer != null:
		Client.stop()
	else:
		toggle_buttons()

func add_player_to_ui(name: String) -> void:
	play_button_sfx()
	var current_player_count = Client.player_info.size()
	
	var texture_index = min(current_player_count, player_textures.size() - 1)
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = player_textures[texture_index]

	if Client.is_creator:
		create_dialog.add_theme_stylebox_override("panel", stylebox)
	else:
		join_dialog.add_theme_stylebox_override("panel", stylebox)
			
func remove_player(index: int) -> void:
	play_button_sfx()
	var current_player_count = max(0, Client.player_info.size() - 1)  # Adjust for removal, ensure no negatives
	
	var texture_index = min(current_player_count, player_textures.size() - 1)
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = player_textures[texture_index]
	
	if Client.is_creator:
		create_dialog.add_theme_stylebox_override("panel", stylebox)
	else:
		join_dialog.add_theme_stylebox_override("panel", stylebox)

func remove_all_players() -> void:
	play_button_sfx()
	var current_player_count = 0
	
	var stylebox = StyleBoxTexture.new()
	stylebox.texture = player_textures[0]
	
	if Client.is_creator:
		create_dialog.add_theme_stylebox_override("panel", stylebox)
		create_dialog.hide()
	else:
		join_dialog.add_theme_stylebox_override("panel", stylebox)
		join_dialog.hide()
		
func toggle_buttons() -> void:
	name_margin_container.visible = !name_margin_container.visible
	button_container.visible = !button_container.visible
	var are_buttons_disabled = create_server_button.disabled and join_server_button.disabled and change_name_button.disabled
	create_server_button.disabled = not are_buttons_disabled
	join_server_button.disabled = not are_buttons_disabled
	change_name_button.disabled = not are_buttons_disabled
	transparent_container.visible = !transparent_container.visible
	connect_v_box_container.show()
	join_dialog_label.text = ""
	
func update_player_count(player_count: int) -> void:
	if Client.is_creator:
		if player_count > 1:
			start_button.disabled = false
		else:
			start_button.disabled = true

func play_button_sfx() -> void:
	if button:
		button.stream = button_sfx
		button.play()

func _on_start_pressed() -> void:
	play_button_sfx()
	Client.start_game()

func show_server_dialog(message: String) -> void:
	server_dialog_text.text = message
	server_dialog.show()

func _on_change_name_button_pressed() -> void:
	play_button_sfx()
	Helper.center_panel(change_name_dialog)
	change_name_dialog.show()
	toggle_buttons()
	edit_name.text = Client.my_info.name
	change_button.disabled = true
	
func _on_change_name_dialog_cancel_pressed() -> void:
	play_button_sfx()
	change_name_dialog.hide()
	toggle_buttons()

func update_lobby_list(lobby_list: Array) -> void:
	for child in lobby_list_container.get_children():
		child.queue_free()
	
	if lobby_list.size() == 0:
		loading_label.text = "No available rooms found!"
		return
	
	for lobby in lobby_list:

		var state_text: String
		var is_disabled: bool = false
		match lobby["state"]:
			0:
				state_text = "WAITING"
			1:
				state_text = "STARTED"
				is_disabled = true
			_:
				state_text = "UNKNOWN"
		
		if lobby["player_count"] >= 5:
			is_disabled = true
		
		var button = Button.new()
		button.text = "Room %d                                                          %d/5" % [lobby["room_id"], lobby["player_count"]]
		button.disabled = is_disabled
		button.connect("pressed", Callable(self, "_join_lobby").bind(lobby["room_id"]))
		button.theme = THEME
		button.theme_type_variation = "SelectServerButton"
		lobby_list_container.add_child(button)
		
		if lobby_list_container.get_child_count() > 0:
			loading_label.hide()
		
func _join_lobby(room_id: int) -> void:
	Client.is_fetching = false
	Client.connect_to_server(room_id)
	
func _set_buttons_state(are_buttons_disabled: bool) -> void:
	create_server_button.disabled = are_buttons_disabled
	join_server_button.disabled = are_buttons_disabled
	change_name_button.disabled = are_buttons_disabled

func _on_server_dialog_confirmed() -> void:
	var should_toggle_visibility = server_dialog_text.text in [
		"Name successfully changed!", 
		"Failed to connect to the server. Please try again.",
		"The room is full. Maximum number of players is reached.",
		"The server has disconnected."
	]
	
	if should_toggle_visibility:
		transparent_container.visible = false
		button_container.visible = true
		if server_dialog_text.text == "The room is full. Maximum number of players is reached.":
			join_dialog.hide()
		elif server_dialog_text.text == "Name successfully changed!" || server_dialog_text.text == "The server has disconnected." || server_dialog_text.text == "Failed to connect to the server. Please try again.":
			name_margin_container.visible = true
	server_dialog.hide()
	_set_buttons_state(false)
