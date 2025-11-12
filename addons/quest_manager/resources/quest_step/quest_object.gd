@icon("res://addons/quest_manager/icons/quest_object.svg")
class_name QuestObject
extends QuestStep


@export var item_count: int = 1
@export var object_type: String = "object_type"
@export var quest_area_id: String = "area_id"


var _items_in_area: int: set = _set_items_in_area
var done: bool = false


func ready() -> void:
	QuestManager.object_entered_area.connect(_on_object_entered_area)


func _set_items_in_area(value: int) -> void:
	_items_in_area = value
	if _items_in_area >= item_count:
		done = true
	else:
		done = false


func _on_object_entered_area(area_id: String, obj_type: String) -> void:
	if area_id == quest_area_id and obj_type == object_type:
		_items_in_area += 1


func _on_object_exited_area(area_id: String, object_type: String) -> void:
	if area_id == quest_area_id and object_type == object_type:
		item_count -= 1
		if _items_in_area < 0:
			_items_in_area = 0
