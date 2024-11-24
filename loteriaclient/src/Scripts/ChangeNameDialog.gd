extends Panel

@onready var edit_name: LineEdit = $MarginContainer/VBoxContainer/EditName
@onready var change_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/Change

func _on_change_pressed() -> void:
	if edit_name.text == "":
		if get_tree().current_scene.name == "Menu":
			var menu = get_tree().current_scene
			menu.show_server_dialog("Name cannot be blank")
	else:
		Client.my_info.name = edit_name.text
		if get_tree().current_scene.name == "Menu":
			var menu = get_tree().current_scene
			menu.name_label.text = "Mabuhay, " + Client.my_info.name + "!"
			menu.show_server_dialog("Name successfully changed!")
			change_button.disabled = true
			menu.change_name_dialog.hide()

func _on_edit_name_text_changed(new_text: String) -> void:
	if edit_name.text == "" || edit_name.text == Client.my_info.name:
		change_button.disabled = true
	else: 
		change_button.disabled = false
