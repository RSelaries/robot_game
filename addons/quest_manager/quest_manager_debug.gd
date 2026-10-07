@icon("res://addons/quest_manager/icons/quest_manger_debug.svg")
class_name QuestManagerDebug
extends ItemList


enum InspectTypes { AVAILABLE_QUEST_POOL, CURRENT_QUEST_STACK, COMPLETED_QUEST_STACK }


@export var inspect_type := InspectTypes.CURRENT_QUEST_STACK


var current_popup: RichTextLabel
var current_popup_item_index: int = -1


func _init() -> void:
	item_clicked.connect(_item_clicked)
	resized.connect(_size_changed)


func _process(delta: float) -> void:
	if not is_visible_in_tree(): return
	
	match inspect_type:
		InspectTypes.AVAILABLE_QUEST_POOL: _update_available()
		InspectTypes.CURRENT_QUEST_STACK: _update_current()
		InspectTypes.COMPLETED_QUEST_STACK: _update_completed()


func _update_available() -> void:
	clear()
	var title = add_item("Available Quests List :")
	set_item_tooltip_enabled(title, false)
	for quest in QuestManager.available_quest_pool:
		var item := add_item(quest.quest_name)
		if current_popup and current_popup_item_index == item:
			current_popup.text = quest.get_as_string()


func _update_current() -> void:
	clear()
	var title = add_item("Current Quests List :")
	set_item_tooltip_enabled(title, false)
	for quest in QuestManager.current_quest_stack:
		var item := add_item(quest.quest_name)
		if current_popup and current_popup_item_index == item:
			print("")
			current_popup.text = quest.get_as_string()


func _update_completed() -> void:
	clear()
	var title = add_item("Completed Quests List :")
	set_item_tooltip_enabled(title, false)
	for quest in QuestManager.completed_quest_stack:
		var item := add_item(quest.quest_name)
		if current_popup and current_popup_item_index == item:
			current_popup.text = quest.get_as_string()


func _custom_item_tooltip(text: String) -> void:
	for child in get_children():
		child.queue_free()
	
	var tooltip := RichTextLabel.new()
	tooltip.text = text
	tooltip.fit_content = true
	tooltip.autowrap_mode = TextServer.AUTOWRAP_OFF
	tooltip.bbcode_enabled = true
	current_popup = tooltip
	
	var panel_container := PanelContainer.new()
	panel_container.add_child(tooltip)
	panel_container.top_level = true
	
	var tooltip_pos: Vector2
	tooltip_pos.x = global_position.x + size.x + 1
	tooltip_pos.y = global_position.y
	
	add_child(panel_container)
	panel_container.position = tooltip_pos


func _item_clicked(index: int, _pos: Vector2, mouse_btn_index: int) -> void:
	if mouse_btn_index != 1: return
	
	if index == 0:
		inspect_type += 1
		inspect_type = inspect_type % 3
		return
	
	if index == current_popup_item_index:
		current_popup_item_index = -1
		for child in get_children():
			child.queue_free()
		return
	
	var quest: QuestResource
	match inspect_type:
		InspectTypes.AVAILABLE_QUEST_POOL:
			quest = QuestManager.available_quest_pool[index - 1]
		InspectTypes.CURRENT_QUEST_STACK:
			quest = QuestManager.current_quest_stack[index - 1]
		InspectTypes.COMPLETED_QUEST_STACK:
			quest = QuestManager.completed_quest_stack[index - 1]
	
	var text := quest.get_as_string()
	current_popup_item_index = index
	_custom_item_tooltip(text)


func _size_changed() -> void:
	var tooltip_pos: Vector2
	tooltip_pos.x = global_position.x + size.x + 1
	tooltip_pos.y = global_position.y
	
	for child in get_children():
		if child is PanelContainer:
			child.position = tooltip_pos
