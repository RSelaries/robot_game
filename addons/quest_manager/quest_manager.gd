# QuestManager autoload
extends Node


signal object_entered_area(area_id: String, object_type: String)
signal object_exited_area(area_id: String, object_type: String)


var available_quest_pool: Array[QuestResource]
var current_quest_stack: Array[QuestResource]
var completed_quest_stack: Array[QuestResource]


# private properties
var _quest_refs: Dictionary[String, QuestResource]


func _ready() -> void:
	await get_tree().create_timer(0).timeout
	
	print(_quest_refs)


func start_quest(quest: Variant) -> void:
	if quest_available(quest):
		var quest_ref = get_quest(quest)
		var quest_index := available_quest_pool.find(quest_ref)
		if quest_index == -1:
			push_error("Cound not find: ", quest_ref, " in available_quest_pool.")
			return
		available_quest_pool.remove_at(quest_index)
		current_quest_stack.append(quest_ref)
	else:
		push_error("Can't start quest: ", quest, " because it was not in available_quest_pool.")


func update_quest(quest: Variant) -> void:
	pass


func quest_available(quest: Variant) -> bool:
	var quest_res := get_quest(quest)
	return quest_res in available_quest_pool


func quest_in_current_stack(quest: Variant) -> bool:
	var quest_res := get_quest(quest)
	return quest_res in current_quest_stack


func quest_completed(quest: Variant) -> bool:
	var quest_res := get_quest(quest)
	return quest_res in completed_quest_stack


func get_quest(quest: Variant) -> QuestResource:
	if quest is String:
		return get_quest_from_name(quest)
	
	if quest is QuestResource:
		return quest
	
	push_error("Could not find a QuestResource based on ", quest, ".")
	return null


func get_quest_from_name(quest_name: String) -> QuestResource:
	var quest: QuestResource = _quest_refs[quest_name]
	
	if quest: return quest
	
	push_error("Could not find a QuestResource based on quest_name: ", quest_name, ".")
	return null
