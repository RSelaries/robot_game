@tool
extends PlayerCompoundState


func get_child_state() -> StateBase:
	var int_comp := player.interaction_shapecast.interactable_component
	
	if int_comp is TalkArea3D:
		return state_machine.get_state("talking")
	
	if int_comp is PickableArea3D:
		return _handle_box_action()
	
	if int_comp is InteractableArea3D:
		return state_machine.get_state("generic_action_1")
	
	if player.held_object != null:
		return state_machine.get_state("put_box_down")
	
	return state_machine.get_state("generic_action_1")


func _handle_box_action() -> StateBase:
	if player.held_object == null:
		return state_machine.get_state("lift_box_up")
	else:
		return state_machine.get_state("put_box_down")


func state_entered() -> void:
	player.disable_movements = true


func state_exited() -> void:
	player.disable_movements = false
