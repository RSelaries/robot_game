class_name QuestComponent
extends Node


@export var quest: QuestResource


func _ready() -> void:
	QuestManager.available_quest_pool.append(quest)
