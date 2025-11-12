@tool
class_name TalkArea3D
extends InteractableArea3D


@export var dialogue: DialogueResource


func _interacted_with() -> void:
	DialogueManager.show_dialogue_balloon(dialogue)
