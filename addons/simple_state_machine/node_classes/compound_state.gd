@icon("res://addons/simple_state_machine/icons/CompoundState.svg")
@tool
class_name CompoundState
extends StateBase


@export var default_state: StateBase


func _state_init(ste_mch_ref: StateMachine) -> void:
	super(ste_mch_ref)
	
	# Initialize every child state
	for child in get_children():
		if child is StateBase:
			child._state_init(ste_mch_ref)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if get_child_count() < 2:
		warnings.append("This State should have at least two State children.")
	
	return warnings


## Override this function to determine the behavior of this compound state when
## it is changed to. (So if the function [code]change_state()[/code] is called
## to change to this state instead of an [AtomicState]).[br]By default, the
## [CompoundState] will return its [param default_state]. If no
## [param default_state] is set its first [StateBase] children will be returned.
func get_child_state() -> StateBase:
	return default_state
