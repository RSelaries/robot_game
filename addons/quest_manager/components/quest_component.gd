@icon("res://addons/quest_manager/icons/quest_component.svg")
class_name QuestComponent
extends Node


@export var quest: QuestResource


func _ready() -> void:
	QuestManager.available_quest_pool.append(quest)
	QuestManager._quest_refs[quest.quest_name] = quest
