@tool
class_name UnprojectMarker
extends Marker3D


@export var node_to_project: Control


func _ready() -> void:
	visibility_changed.connect(func():
		if node_to_project: node_to_project.visible = visible
	)
	visible = false


func _process(_d: float) -> void:
	if Engine.is_editor_hint(): return
	
	var cam_3d := get_viewport().get_camera_3d()
	var pos_2d := cam_3d.unproject_position(global_position)
	node_to_project.position = pos_2d
