extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	QuestManager.quest_updated.connect(_update)


func _update(_params) -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for quest in QuestManager.current_quest_stack:
		add_child(PlayerQuestGUI.new(quest))
