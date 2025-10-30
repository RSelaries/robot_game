@tool
@icon("res://addons/simple_state_machine/icons/StateMachine.svg")
class_name StateMachine
extends StateMachineBase


# ==============================================================================
# Private Variables
# ==============================================================================
var _root_state: StateBase
var _states: Array[StateBase]


# ==============================================================================
# Private Functions
# ==============================================================================
func _ready() -> void:
	child_order_changed.connect(_on_child_order_changed)
	
	if Engine.is_editor_hint(): return # The rest only run in game

	# check if we have exactly one child that is a state
	if get_child_count() != 1:
		push_error("StateMachine must have exactly one child")
		return
	
	# check if the child is a state
	var child: Node = get_child(0)
	if child is StateBase:
		_root_state = child
	else:
		push_error("StateMachine's child must be a State")
		return
	
	_root_state._state_init(self)
	
	# We wait one frame before entering initial state, so parents of the state
	# chart have a chance to run their _ready methods first
	_enter_initial_state.call_deferred()
	await get_tree().create_timer(0).timeout


func _enter_initial_state() -> void:
	_root_state._state_enter()


func _on_child_order_changed() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	if get_children().size() != 1:
		warnings.append("The StateMachine should have one (and only one) State node as a direct child.")
	elif get_child(0) is not StateBase:
		warnings.append("The child must be a State, i.e AtomicState,
		CompoundState or ParallelState.")

	return warnings


# ==============================================================================
# Public Functions
# ==============================================================================
#func change_state(state_name: String) -> void:
	#for state in _states:
		#if state == _root_state: continue # Root state is already active
		#
		#if state.state_name == state_name:
			#state.change_to_this_state(state)

func change_state(state_name: String) -> void:
	# Cherche l'état correspondant au nom donné
	var target_state: StateBase = null
	for state in _states:
		if state.state_name == state_name:
			target_state = state
			break
	
	if not target_state:
		push_warning("State '%s' not found in StateMachine." % state_name)
		return
	
	# Trouve l'état actuellement actif (celui qui est au plus profond)
	var active_state := _find_active_state(_root_state)
	if not active_state:
		push_error("No active state found in StateMachine.")
		return
	
	# Si la cible est déjà active, on ne fait rien
	if target_state == active_state:
		return
	
	# Transition propre : l'état actif change vers la cible
	active_state.change_to_this_state(target_state)


func _find_active_state(from_state: StateBase) -> StateBase:
	if from_state is CompoundState and from_state.enabled_state_child:
		return _find_active_state(from_state.enabled_state_child)
	return from_state
