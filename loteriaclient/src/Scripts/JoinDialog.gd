extends Panel

@onready var join_dialog: Panel = $"."
@onready var connect_container: VBoxContainer = $ScrollContainer/MainContainer/ConnectVBoxContainer
@onready var error_label: Label = $ScrollContainer/MainContainer/ConnectVBoxContainer/ErrorLabel
@onready var wait_container: VBoxContainer = $ScrollContainer/MainContainer/VBoxContainer
@onready var room_label: Label = $ScrollContainer/MainContainer/VBoxContainer/Label
@onready var lobby_list: VBoxContainer = $ScrollContainer/MainContainer/ConnectVBoxContainer/LobbyList
		
func connected_ok() -> void:
	connect_container.hide()
	error_label.text = ""
	wait_container.show()
	
func show_error(msg: String) -> void:
	error_label.text = msg
	error_label.show()
