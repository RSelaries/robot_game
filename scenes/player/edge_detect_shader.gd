@tool
extends MeshInstance3D


@export var enable_on_ready: bool = true


func _ready() -> void:
	if Engine.is_editor_hint(): visible = false
	elif enable_on_ready: visible = true
