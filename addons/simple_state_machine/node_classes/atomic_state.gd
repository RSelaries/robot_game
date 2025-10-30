@icon("res://addons/simple_state_machine/icons/AtomicState.svg")
@tool
class_name AtomicState
extends StateBase


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super._get_configuration_warnings()
	
	for child in get_children():
		if child is StateBase:
			warnings.append("An AtomicState is not supposed to have a State as a child.")
			break
	
	return warnings
