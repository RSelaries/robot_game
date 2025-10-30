@icon("res://addons/simple_state_machine/icons/CompoundState.svg")
@tool
class_name CompoundState
extends StateBase


@export var default_state: StateBase:
	set(value):
		default_state = value
		update_configuration_warnings()


var enabled_state_child: StateBase


func _state_init(ste_mch_ref: StateMachine) -> void:
	super(ste_mch_ref)
	if not default_state:
		push_error("This compound state node doesn't have a default state set.")
	
	# Initialize every child state
	for child in get_children():
		if child is StateBase:
			child._state_init(ste_mch_ref)
	
	enabled_state_child = default_state


func _state_enter() -> void:
	super()
	enabled_state_child._state_enter()


func _state_exit() -> void:
	super()
	enabled_state_child._state_exit()
	enabled_state_child = default_state


func _change_active_state(state: StateBase) -> void:
	if enabled_state_child == state: return # Already Active
	if enabled_state_child: enabled_state_child._state_exit()
	enabled_state_child = state
	if not enabled_state_child._state_active: 
		enabled_state_child._state_enter()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings := super()
	
	if not default_state:
		warnings.append("A default state must be set.")
	
	return warnings
