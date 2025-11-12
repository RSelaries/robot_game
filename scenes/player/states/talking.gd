@tool
extends PlayerAtomicState


func state_entered() -> void:
	var int_comp := player.interaction_shapecast.interactable_component
	if int_comp is TalkArea3D:
		int_comp.interact()
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _on_dialogue_ended(_res) -> void:
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)
	change_state("no_action")
