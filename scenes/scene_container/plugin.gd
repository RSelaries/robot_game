@tool
extends EditorPlugin


const autoload_path := "res://addons/scene_manager/scene_manager.gd"


func _enable_plugin() -> void:
	add_autoload_singleton("SceneManager", autoload_path)

func _disable_plugin() -> void:
	remove_autoload_singleton("SceneManager")


func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass
