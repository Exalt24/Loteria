extends Panel

@onready var connect_container: VBoxContainer = $VBoxContainer/MarginContainer/ScrollContainer/ConnectVBoxContainer
@onready var room_label: Label = $VBoxContainer/VBoxContainer/MarginContainer/LabelContainer/Label
@onready var wait_label: Label = $VBoxContainer/VBoxContainer/MarginContainer/LabelContainer/WaitLabel
@onready var waiting_host_label: Label = $"../../WaitingHostLabel"

func connected_ok() -> void:
	connect_container.hide()
	wait_label.text = "Tayo'y Maghintay!"
	waiting_host_label.text = "Waiting for host to start the game..."
