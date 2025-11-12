@icon("res://addons/quest_manager/icons/quest_manger_debug.svg")
class_name QuestManagerDebug
extends ItemList


enum InspectTypes { AVAILABLE_QUEST_POOL, CURRENT_QUEST_STACK, COMPLETED_QUEST_STACK }


@export var inspect_type := InspectTypes.CURRENT_QUEST_STACK


func _init() -> void:
	item_clicked.connect(_item_clicked)


func _process(_d) -> void:
	match inspect_type:
		InspectTypes.AVAILABLE_QUEST_POOL: _update_available()
		InspectTypes.CURRENT_QUEST_STACK: _update_current()
		InspectTypes.COMPLETED_QUEST_STACK: _update_completed()


func _update_available() -> void:
	clear()
	add_item("Available Quests List :")
	for quest in QuestManager.available_quest_pool:
		add_item(quest.quest_name)


func _update_current() -> void:
	clear()
	add_item("Current Quests List :")
	for quest in QuestManager.current_quest_stack:
		add_item(quest.quest_name)


func _update_completed() -> void:
	clear()
	add_item("Completed Quests List :")
	for quest in QuestManager.completed_quest_stack:
		add_item(quest.quest_name)


func _item_clicked(index: int, _pos: Vector2, mouse_btn_index: int) -> void:
	if index == 0 and mouse_btn_index == 1:
		inspect_type += 1
		inspect_type = inspect_type % 3
