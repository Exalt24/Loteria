extends Panel

@onready var join_dialog: Panel = $"."
@onready var connect_container: VBoxContainer = $ScrollContainer/MainContainer/ConnectVBoxContainer
@onready var error_label: Label = $ScrollContainer/MainContainer/ConnectVBoxContainer/ErrorLabel
@onready var spin_box: SpinBox = $ScrollContainer/MainContainer/ConnectVBoxContainer/SpinBox
@onready var wait_container: VBoxContainer = $ScrollContainer/MainContainer/VBoxContainer
@onready var room_label: Label = $ScrollContainer/MainContainer/VBoxContainer/Label
@onready var connect_button: Button = $ScrollContainer/MainContainer/ButtonContainer/Connect

func _on_join_dialog_connect_pressed() -> void:
	if connect_button.text == "Connect":
		connect_button.disabled = true
		Client.connect_to_server(spin_box.value)
		join_dialog.show()
	else:
		Client.stop()
		connect_button.text = "Connect"
		connect_button.disabled = false
		wait_container.hide()
		join_dialog.show()
		connect_container.show()
		
func connected_ok() -> void:
	connect_container.hide()
	error_label.text = ""
	connect_button.disabled = false
	connect_button.text = "Disconnect"
	wait_container.show()
	
func show_error(msg: String) -> void:
	error_label.text = msg
	error_label.show()
	
	if error_label.text != "":
		connect_button.disabled = false
