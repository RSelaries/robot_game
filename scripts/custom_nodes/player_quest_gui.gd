@tool
class_name PlayerQuestGUI
extends PanelContainer


var quest_res: QuestResource

var name_label: RichTextLabel
var content_label: RichTextLabel


func _init(quest: QuestResource) -> void:
	QuestManager.quest_updated.connect(_on_quest_update)
	
	quest_res = quest
	
	name_label = RichTextLabel.new()
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	name_label.bbcode_enabled = true
	name_label.fit_content = true
	name_label.text = "Name"
	
	content_label = RichTextLabel.new()
	content_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	content_label.bbcode_enabled = true
	content_label.fit_content = true
	content_label.text = "Content"
	
	var vbox := VBoxContainer.new()
	vbox.add_child(name_label)
	vbox.add_spacer(false)
	vbox.add_child(content_label)
	add_child(vbox)
	
	_on_quest_update(quest)


func _on_quest_update(quest: QuestResource) -> void:
	if quest != quest_res or quest_res == null: return
	
	name_label.text = quest_res.quest_name
	content_label.text = quest.get_as_string()
