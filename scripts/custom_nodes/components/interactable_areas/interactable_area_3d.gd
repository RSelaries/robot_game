@tool
@icon("res://assets/icons/interactable_area_3d.svg")
class_name InteractableArea3D
extends Area3D


signal interacted_with
signal gained_focus
signal lost_focus


@export var show_on_focus: Array[Node3D]


var focused: bool = false: set = _set_focused


func _ready() -> void:
	collision_layer = 2
	collision_mask = 2
	for node in show_on_focus:
		node.visible = false


func interact() -> void:
	interacted_with.emit()
	_interacted_with()


func _interacted_with() -> void:
	pass


func _set_focused(value):
	if value:
		gained_focus.emit()
		for node in show_on_focus:
			node.visible = true
		_gained_focus()
	else:
		lost_focus.emit()
		for node in show_on_focus:
			node.visible = false
		_lost_focus()


func _gained_focus() -> void:
	pass

func _lost_focus() -> void:
	pass
