@icon("res://addons/quest_manager/icons/quest_resource.svg")
class_name QuestResource
extends Resource


@export var quest_name: String
@export var quest_steps: Array[QuestStep]


func ready() -> void:
	for step in quest_steps:
		step.ready()
		step.step_updated.connect(_on_step_updated)
	if quest_steps.size() > 0:
		quest_steps[0].previous_step_done = true


func get_as_string() -> String:
	var text: String = quest_name
	for step in quest_steps:
		text += "\n"
		text += step.get_as_string()
	return text


func _to_string() -> String:
	return '<QuestResource:%s>' % quest_name


func _on_step_updated() -> void:
	QuestManager.quest_updated.emit(self)
	
	for step in quest_steps:
		if step.done == false:
			return
	
	QuestManager.complete_quest(self)
