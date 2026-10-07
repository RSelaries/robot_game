@tool
class_name SceneContainer
extends Node


static func get_current_scene() -> Node:
	if Global.scene_container.get_child(0):
		return Global.scene_container.get_child(0)
	else: return Global.get_tree().current_scene


func change_child(node: Node, force_reload := false) -> void:
	if get_child_count() != 0:
		if force_reload:
			remove_child(node)
			add_child(node)
			return
		if node == get_child(0):
			return
	
	for child in get_children():
		child.queue_free()
	
	add_child(node)


func _enter_tree() -> void:
	Global.scene_container = self
