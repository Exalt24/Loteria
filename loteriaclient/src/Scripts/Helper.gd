extends Node

func center_panel(panel: Control) -> void:
	var viewport_center = get_viewport().get_visible_rect().size / 2
	panel.position = viewport_center - (panel.size / 2)
