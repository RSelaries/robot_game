@icon("res://addons/quest_manager/quest_resource.svg")
class_name QuestResource
extends Resource


enum OrderType {
	UNORDERED, ## The quest items can be completed in any order.
	ORDERED, ## The quest items have to be completed in order.
}


@export var quest_name: String
@export var order_type := OrderType.UNORDERED
@export var quest_item_stack: Array[QuestItem]


#func _init() -> void:
	#QuestManager._quest_refs[quest_name] = self


func set_quest_name(value: String) -> void:
	quest_name = value
