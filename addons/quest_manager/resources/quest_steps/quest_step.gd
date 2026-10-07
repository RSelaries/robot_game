@icon("res://addons/quest_manager/icons/quest_item.svg")
@abstract
class_name QuestStep
extends Resource


signal step_updated


@export var step_title: String


@abstract func ready() -> void
@abstract func get_as_string() -> String


var previous_step_done: bool = false
var done: bool = false:
	set(value):
		done = value
		step_updated.emit()
