@tool
class_name InteractableArea3D
extends Area3D


signal gained_focus
signal lost_focus


var focused: bool = false: set = _set_focused


func _ready() -> void:
	collision_layer = 2
	collision_mask = 2


func _set_focused(value):
	if value:
		gained_focus.emit()
		_gained_focus()
	else:
		lost_focus.emit()
		_lost_focus()


func _gained_focus() -> void:
	pass

func _lost_focus() -> void:
	pass
