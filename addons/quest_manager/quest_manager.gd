# QuestManager autoload
extends Node


signal quest_updated(quest: QuestResource)


signal object_entered_area(area_id: String, object_type: String)
signal object_exited_area(area_id: String, object_type: String)

signal quest_talk_sent(quest_talk_id: String)


var available_quest_pool: Array[QuestResource]
var current_quest_stack: Array[QuestResource]
var completed_quest_stack: Array[QuestResource]


# private properties
var _quest_refs: Dictionary[String, QuestResource]


func _ready() -> void:
	await get_tree().create_timer(0).timeout
	
	print(_quest_refs)


func quest_talk(talk_id: String) -> void:
	quest_talk_sent.emit(talk_id)


func start_quest(quest: Variant) -> void:
	if is_quest_available(quest):
		var quest_ref = get_quest(quest)
		var quest_index := available_quest_pool.find(quest_ref)
		if quest_index == -1:
			push_error("Cound not find: ", quest_ref, " in available_quest_pool.")
			return
		available_quest_pool.remove_at(quest_index)
		current_quest_stack.append(quest_ref)
		quest_updated.emit(quest_ref)
	else:
		push_error("Can't start quest: ", quest, " because it was not in available_quest_pool.")


func complete_quest(quest: Variant) -> void:
	if is_quest_in_current_stack(quest):
		var quest_ref = get_quest(quest)
		var quest_index := current_quest_stack.find(quest_ref)
		if quest_index == -1:
			push_error("Cound not find: ", quest_ref, " in current_quest_stack.")
			return
		current_quest_stack.remove_at(quest_index)
		completed_quest_stack.append(quest_ref)
		quest_updated.emit(quest_ref)


func update_quest(quest: Variant) -> void:
	quest_updated.emit(quest)


func is_quest_available(quest: Variant) -> bool:
	var quest_res := get_quest(quest)
	return quest_res in available_quest_pool


func is_quest_in_current_stack(quest: Variant) -> bool:
	var quest_res := get_quest(quest)
	return quest_res in current_quest_stack


func is_quest_completed(quest: Variant) -> bool:
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
