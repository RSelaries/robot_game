@tool
extends PlayerCompoundState


func get_child_state() -> StateBase:
	if player.held_object == null and player.stored_object != null:
		return state_machine.get_state("get_stored_box")
	
	if player.held_object != null and player.stored_object == null:
		return state_machine.get_state("store_box")
	
	return state_machine.get_state("generic_action_2")


func state_entered() -> void:
	player.disable_movements = true


func state_exited() -> void:
	player.disable_movements = false
