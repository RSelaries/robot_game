@tool
extends PlayerCompoundState


func get_child_state() -> StateBase:
	#var int_comp := player.interaction_shapecast.interactable_component
	
	if player.held_object == null and player.stored_object != null:
		return state_machine.get_state("get_store_box")
	
	if player.held_object != null and player.stored_object == null:
		return state_machine.get_state("store_box")
	
	return state_machine.get_state("generic_action_2")
