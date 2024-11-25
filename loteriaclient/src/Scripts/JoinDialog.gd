extends Panel

@onready var join_dialog: Panel = $"."
@onready var select_room_dialog: Panel = $"../../SelectRoomDialog"
@onready var room_label: Label = $VBoxContainer/MarginContainer/LabelContainer/Label
@onready var wait_label: Label = $VBoxContainer/MarginContainer/LabelContainer/WaitLabel
@onready var waiting_host_label: Label = $"../../WaitingHostLabel"

func connected_ok() -> void:
	select_room_dialog.hide()
	Helper.center_panel(join_dialog)
	join_dialog.show()
	wait_label.text = "Tayo'y Maghintay!"
	waiting_host_label.text = "Waiting for host to start the game..."
