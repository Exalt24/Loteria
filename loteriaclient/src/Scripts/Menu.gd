extends Control

var game_started: bool = false
var keep_join_dialog_open: bool = false

@onready var create_dialog: Panel = $CreateDialog
@onready var create_dialog_label: Label = $CreateDialog/ScrollContainer/VBoxContainer/LabelContainer/Label
@onready var create_dialog_player_list: VBoxContainer = $CreateDialog/ScrollContainer/VBoxContainer/LabelContainer/PlayerList
@onready var join_dialog: Panel = $JoinDialog
@onready var join_dialog_label: Label = $JoinDialog/ScrollContainer/MainContainer/VBoxContainer/Label
@onready var join_dialog_player_list: VBoxContainer = $JoinDialog/ScrollContainer/MainContainer/VBoxContainer/PlayerList
@onready var create_server_button: Button = $VBoxContainer/VBoxContainer/CreateServerButton
@onready var join_server_button: Button = $VBoxContainer/VBoxContainer/JoinServerButton
@onready var change_name_button: Button = $VBoxContainer/VBoxContainer/ChangeNameButton
@onready var connect_button: Button = $JoinDialog/ScrollContainer/MainContainer/ButtonContainer/Connect
@onready var connect_v_box_container: VBoxContainer = $JoinDialog/ScrollContainer/MainContainer/ConnectVBoxContainer
@onready var start_button: Button = $CreateDialog/ScrollContainer/VBoxContainer/HBoxContainer/Start
@onready var error_label: Label = $JoinDialog/ScrollContainer/MainContainer/ConnectVBoxContainer/ErrorLabel
@onready var server_dialog: AcceptDialog = $ServerDialog
@onready var change_name_dialog: Panel = $ChangeNameDialog
@onready var edit_name: LineEdit = $ChangeNameDialog/MarginContainer/VBoxContainer/EditName
@onready var name_label: Label = $VBoxContainer/NameContainer/NameLabel
@onready var change_button: Button = $ChangeNameDialog/MarginContainer/VBoxContainer/HBoxContainer/Change


var timeout_timer: Timer = null 

func _ready() -> void:
	start_button.disabled = true
	name_label.text = "Hello, " + Client.my_info.name
	timeout_timer = Timer.new()
	timeout_timer.one_shot = true
	timeout_timer.wait_time = 10
	timeout_timer.connect("timeout", Callable(self, "_on_timeout"))
	add_child(timeout_timer)

func update_room(room_id: int) -> void:
	if Client.is_creator:
		create_dialog_label.text = "Room id: " + str(room_id)
	else:
		join_dialog_label.text = "Room id: " + str(room_id)
		join_dialog.connected_ok()
	stop_timeout_timer()

func _on_create_server_button_pressed() -> void:
	Client.create_room({})
	Helper.center_panel(create_dialog)
	create_dialog.show()
	toggle_buttons()
	start_timeout_timer()

func _on_create_dialog_cancel_pressed() -> void:
	create_dialog.hide()
	stop_timeout_timer()
	if self.multiplayer.multiplayer_peer != null:
		Client.stop()
	toggle_buttons()
		
func _on_join_server_button_pressed() -> void:
	Helper.center_panel(join_dialog)
	join_dialog.show()
	toggle_buttons()

func _on_join_dialog_cancel_pressed() -> void:
	join_dialog.hide()
	error_label.text = ""
	if self.multiplayer.multiplayer_peer != null:
		Client.stop()
	else:
		toggle_buttons()

func add_player_to_ui(name: String) -> void:
	if Client.is_creator:
		create_dialog_player_list.add_player(name)
	else:
		join_dialog_player_list.add_player(name)
			
func remove_player(index: int) -> void:
	if Client.is_creator:
		create_dialog_player_list.remove_player(index)
	else:
		join_dialog_player_list.remove_player(index)

func remove_all_players() -> void:
	if Client.is_creator:
		create_dialog_player_list.remove_all()
		create_dialog.hide()
	else:
		join_dialog_player_list.remove_all()
		if keep_join_dialog_open:
			keep_join_dialog_open = false
		else:
			join_dialog.hide()
		
func toggle_buttons() -> void:
	var are_buttons_disabled = create_server_button.disabled and join_server_button.disabled and change_name_button.disabled
	create_server_button.disabled = not are_buttons_disabled
	join_server_button.disabled = not are_buttons_disabled
	change_name_button.disabled = not are_buttons_disabled
	connect_button.text = "Connect"
	connect_button.disabled = false
	connect_v_box_container.show()
	join_dialog_label.text = ""

func mini_toggle_buttons() -> void:
	var are_buttons_disabled = create_server_button.disabled and join_server_button.disabled and change_name_button.disabled
	change_name_button.disabled = not are_buttons_disabled
	create_server_button.disabled = not are_buttons_disabled
	join_server_button.disabled = not are_buttons_disabled
	
func update_player_count(player_count: int) -> void:
	if Client.is_creator:
		if player_count > 1:
			start_button.disabled = false
		else:
			start_button.disabled = true

func _on_start_pressed() -> void:
	Client.start_game()

func start_timeout_timer() -> void:
	timeout_timer.start()

func stop_timeout_timer() -> void:
	if timeout_timer.is_stopped() == false:
		timeout_timer.stop()

func _on_timeout() -> void:
	show_server_dialog("The server is not responding. Please check your connection and try again.")

func show_server_dialog(message: String) -> void:
	server_dialog.dialog_text = message
	server_dialog.popup_centered()

func _on_server_dialog_confirmed() -> void:
	connect_button.disabled = false

func _on_change_name_button_pressed() -> void:
	Helper.center_panel(change_name_dialog)
	change_name_dialog.show()
	toggle_buttons()
	edit_name.text = Client.my_info.name
	change_button.disabled = true
	
func _on_change_name_dialog_cancel_pressed() -> void:
	change_name_dialog.hide()
	toggle_buttons()
