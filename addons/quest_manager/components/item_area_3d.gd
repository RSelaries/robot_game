@icon("res://addons/quest_manager/icons/quest_area_3d.svg")
class_name QuestItemArea3D
extends Area3D



@export var area_id: String = "area_id"

@export_group("Objects")
@export var objects_enabled: bool = true
@export var object_id: String
@export var object_needed_count: int = 1


func _init() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)


func _body_entered(body: Node3D) -> void:
	var object_comp: QuestObjectComponent
	for child in body.get_children():
		if child is QuestObjectComponent:
			object_comp = child
			break
	if not object_comp: return
	QuestManager.object_entered_area.emit(area_id, object_comp.type_name)


func _body_exited(body: Node3D) -> void:
	var object_comp: QuestObjectComponent
	for child in body.get_children():
		if child is QuestObjectComponent:
			object_comp = child
			break
	if not object_comp: return
	QuestManager.object_exited_area.emit(area_id, object_comp.type_name)
