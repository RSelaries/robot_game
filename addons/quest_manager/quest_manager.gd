# QuestManager autoload
extends Node


var _quest_refs: Dictionary[String, QuestResource]
var available_quest_pool: Array[QuestResource]
var current_quest_stack: Array[QuestResource]
var completed_quest_stack: Array[QuestResource]


func start_quest(quest: Variant) -> void:
	pass


func update_quest(quest: Variant) -> void:
	pass


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
