class_name QuestTalk
extends QuestStep


@export var talk_id: String


func ready() -> void:
	QuestManager.quest_talk_sent.connect(_on_quest_talk_sent)


func get_as_string() -> String:
	var text: String
	if done:
		text += "[color=green]"
	text += "talk id: "
	text += talk_id
	if done:
		text += "[/color]"
	return text


func _on_quest_talk_sent(quest_talk_id: String) -> void:
	if quest_talk_id == talk_id:
		done = true
