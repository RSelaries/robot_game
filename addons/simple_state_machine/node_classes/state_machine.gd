@tool
@icon("res://addons/simple_state_machine/icons/StateMachine.svg")
class_name StateMachine
extends StateMachineBase


signal state_changed(to: StateBase)


@export var initial_state: StateBase:
	set(value):
		initial_state = value
		update_configuration_warnings()


var active_state: StateBase = null:
	set(value):
		active_state = value
		state_changed.emit(value)

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
	
	# check if the child is a state
	for child in get_children():
		if child is StateBase:
			child._state_init(self)
	
	# We wait one frame before entering initial state, so parents of the state
	# chart have a chance to run their _ready methods first
	_enter_initial_state.call_deferred()


func _enter_initial_state() -> void:
	if initial_state:
		change_state(initial_state)
	else:
		push_error("[", name, "] ", "No initial state set.")


func _get_state_from_name(state_name: String) -> StateBase:
	for _state in _states:
		if _state.state_name == state_name or _state.name == state_name:
			return _state
	push_error("[", name, "] ", "Could not find State based on '", state_name, "'.")
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


func _on_child_order_changed() -> void:
	update_configuration_warnings()


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not initial_state:
		warnings.append("An initial state must be set.")
	else:
		if name not in get_state_ancestors_name(initial_state):
			warnings.append("The initial state must be a child of the state machine.")
	
	return warnings


# ==============================================================================
# Public Functions
# ==============================================================================
func get_state_ancestors_name(state: StateBase) -> Array[String]:
	var ancestors: Array[String] = []
	var current: Node = state
	while current is StateBase:
		ancestors.append(current.name)
		current = current.get_parent()
	if current is StateMachine:
		ancestors.append(current.name)
	return ancestors


## [param state] must either be a [String] name of the state or a direct
## reference to the [StateBase]. If a [String] name is passed, it must either
## be the exact [param name] of the node (case sensitive) or a 'snake_case'
## version of it.[br]For exemple, to enter [CrouchWalking] state you can call:
## [codeblock]change_state("CrouchWalking")[/codeblock] or [codeblock]
## change_state("crouch_walking)[/codeblock]
func change_state(state: Variant, called_by: Node = null) -> void:
	if called_by: print(called_by)
	
	var state_ref: StateBase
	if state is String: state_ref = _get_state_from_name(state)
	elif state is StateBase: state_ref = state
	else: push_error("[", name, "] ", "Couldn't find the target state: ", state, ". [param state should be \
	either a [String] name of a state or a direct reference.")
	
	while state_ref is CompoundState:
		state_ref = state_ref.get_child_state()
	
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
