@icon("res://addons/quest_manager/icons/quest_object.svg")
class_name QuestObject
extends QuestStep


@export var item_count: int = 1
@export var object_type: String = "object_type"
@export var quest_area_id: String = "area_id"


var _items_in_area: int = 0
var done: bool = false


func _init() -> void:
	QuestManager.object_entered_area.connect(_on_object_entered_area)


func _on_object_entered_area(area_id: String, object_type: String) -> void:
	if area_id == quest_area_id and object_type == object_type:
		pass


func _on_object_exited_area(area_id: String, object_type: String) -> void:
	if area_id == quest_area_id and object_type == object_type:
		pass
