@icon("res://assets/icons/separator.png")
@tool
class_name SeparatorNode
extends Node


@export var shown_name: String:
	set(value):
		shown_name = value
		name = "≡≡≡≡ " + value + " ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡"


func _init() -> void:
	if not Engine.is_editor_hint():
		queue_free()
