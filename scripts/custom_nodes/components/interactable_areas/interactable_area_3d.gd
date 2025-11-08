class_name InteractableArea3D
extends Area3D


signal gained_focus
signal lost_focus


var focused: bool = false: set = _set_focused


func _init() -> void:
	collision_layer = 2
	collision_mask = 2


func _set_focused(value):
	if value: gained_focus.emit()
	else: lost_focus.emit()
