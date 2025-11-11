@tool
extends PlayerAtomicState


func state_entered() -> void:
	var int_comp := player.interaction_shapecast.interactable_component
	if int_comp is InteractableArea3D:
		int_comp.interact()
	change_state("no_action")
