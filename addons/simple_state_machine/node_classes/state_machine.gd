@tool
@icon("res://addons/simple_state_machine/icons/StateMachine.svg")
class_name StateMachine
extends StateMachineBase


@export var initial_state: AtomicState


var active_state: StateBase = null

# ==============================================================================
# Private Variables
# ==============================================================================
var _states: Array[StateBase]


# ==============================================================================
# Private Functions
# ==============================================================================
func _ready() -> void:
	child_order_changed.connect(_on_child_order_changed)
	
	if Engine.is_editor_hint(): return # The rest only run in game

	# check if we have exactly one child that is a state
	#if get_child_count() != 1:
		#push_error("StateMachine must have exactly one child")
		#return
	
	# check if the child is a state
	for child in get_children():
		if child is StateBase:
			child._state_init(self)
	
	# We wait one frame before entering initial state, so parents of the state
	# chart have a chance to run their _ready methods first
	_enter_initial_state.call_deferred()


func _enter_initial_state() -> void:
	change_state(initial_state)


func _on_child_order_changed() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []

	#if get_children().size() != 1:
		#warnings.append("The StateMachine should have one (and only one) State node as a direct child.")
	#elif get_child(0) is not StateBase:
		#warnings.append("The child must be a State, i.e AtomicState,
		#CompoundState or ParallelState.")

	return warnings


# ==============================================================================
# Public Functions
# ==============================================================================

## [param state] must either be a [String] name of the state or a direct
## reference to the [StateBase]
func change_state(state: Variant) -> void:
	var state_ref: StateBase
	if state is String: state_ref = _get_state_from_name(state)
	elif state is StateBase: state_ref = state
	else: push_error("Couldn't find the target state. [param state should be\
	either a [String] name of a state or a direct reference.")
	
	# Don't change if already in this state
	if state_ref == active_state: return
	
	# 1. Find commom encestor
	var commom_ancestor: StateBase = null
	
	# 2. Get all nodes from active state to common ancestor
	var exit_list: Array[StateBase] = []
	var target: Node = active_state
	commom_ancestor = _find_common_ancestor(active_state, state_ref)
	while target is StateBase and target != commom_ancestor:
		exit_list.append(target)
		target = target.get_parent()
	
	# 3. Exit thoses states
	for ext_state in exit_list:
		ext_state._state_exit()
	
	# 4. Get all nodes from target state to common ancestor
	var enter_list: Array[StateBase] = []
	target = state_ref
	while target is StateBase and target != commom_ancestor:
		enter_list.append(target)
		target = target.get_parent()
	
	# 5. Enter all states
	active_state = state_ref
	for i in enter_list.size():
		enter_list[-i - 1]._state_enter()


func _get_state_from_name(state_name: String) -> StateBase:
	for _state in _states:
		if _state.state_name == state_name:
			return _state
	push_error("Could not find State based on '", state_name, "'.")
	return null


## [param from] being the current state and [param to] being the target state.
func _find_common_ancestor(from: StateBase, to: StateBase) -> StateBase:
	if from == null: return null # In the init phase
	
	# Get ancestors of active State
	var from_state_ancestors: Array[StateBase] = []
	var current: Node = from
	while current is StateBase:
		from_state_ancestors.append(current)
		current = current.get_parent()
	
	# If target state ancestor has a parent in commom, return it
	current = to
	while current is StateBase:
		if current in from_state_ancestors:
			return current
		current = current.get_parent()
	return null
