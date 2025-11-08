@tool
extends PlayerCompoundState


func get_child_state() -> StateBase:
	var int_comp := player.interaction_shapecast.interactable_component
	
	if int_comp is TalkArea3D:
		return state_machine.get_state("talking")
	
	if int_comp is PickableArea3D:
		return _handle_box_action()
	
	return state_machine.get_state("generic_action_1")


func _handle_box_action() -> StateBase:
	return default_state
