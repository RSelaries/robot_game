@tool
extends EditorPlugin


const QuestManagerEditorScene = preload("uid://dipg3cleip0jn")


var manager_editor_scene: Control


func _enable_plugin() -> void:
	add_autoload_singleton("QuestManager", "res://addons/quest_manager/quest_manager.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton("QuestManager")


func _get_plugin_name() -> String:
	return "Quest Manager"

func _get_plugin_icon() -> Texture2D:
	return preload("uid://bu7aqb1b06pev")


# ==============================================================================
# Editor Main Screen
# ==============================================================================
#func _has_main_screen() -> bool:
	#return true

#func _make_visible(visible: bool) -> void:
	#if manager_editor_scene:
		#manager_editor_scene.visible = visible


#func _enter_tree() -> void:
	#manager_editor_scene = QuestManagerEditorScene.instantiate()
	#EditorInterface.get_editor_main_screen().add_child(manager_editor_scene)
	#_make_visible(false)
#
#func _exit_tree() -> void:
	#if manager_editor_scene:
		#manager_editor_scene.queue_free()
