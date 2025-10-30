@icon("res://addons/simple_state_machine/icons/StateBase.svg")
@tool @abstract
class_name StateBase
extends StateMachineBase


var state_name: String:
	get(): return _pascal_to_snake(name)


var state_machine: StateMachine
var _state_active: bool = false


func _ready() -> void:
	_state_active = false
	state_name = _pascal_to_snake(name)
	
	if Engine.is_editor_hint():
		return


func _state_init(ste_mch_ref: StateMachine) -> void:
	# This Should init the state and its children states (if any)
	_state_active = false
	state_machine = ste_mch_ref
	state_machine._states.append(self)


func _state_enter() -> void:
	if _state_active: return # Can't enter twice
	
	_state_active = true
	print(state_name, " entered !")
	state_entered()


func _state_exit() -> void:
	if not _state_active: return # Can't exit twice
	
	_state_active = false
	print(state_name, " exited !")
	state_exited()


func _process(delta: float) -> void:
	if _state_active: update(delta)

func _physics_process(delta: float) -> void:
	if _state_active: physics_update(delta)
	
func _unhandled_input(event: InputEvent) -> void:
	if _state_active: state_input(event)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	return warnings


func _pascal_to_snake(string: String) -> String:
	# Ajoute un underscore avant chaque majuscule sauf la première
	var regex1 := RegEx.new()
	regex1.compile("(?<!^)([A-Z])")
	string = regex1.sub(string, "_$1")

	# Ajoute un underscore avant les chiffres sauf s'il y en a déjà un
	var regex2 := RegEx.new()
	regex2.compile("(?<!_)([0-9])")
	string = regex2.sub(string, "_$1")

	# Gère le cas des lettres majuscules après un chiffre (ex: 1Node -> 1_Node)
	var regex3 := RegEx.new()
	regex3.compile("([0-9])([A-Z])")
	string = regex3.sub(string, "$1_$2")

	# Supprime l'underscore entre un 2 ou 3 et la lettre D (pour garder 2D / 3D collé)
	var regex4 := RegEx.new()
	regex4.compile("([23])_D")
	string = regex4.sub(string, "$1D")

	return string.to_lower()


# ==============================================================================
# Overridable functions
# ==============================================================================
func update(delta: float) -> void: pass
func physics_update(delta: float) -> void: pass
func state_input(event: InputEvent) -> void: pass
func state_entered() -> void: pass # TODO: Call
func state_exited() -> void: pass # TODO: Call


# ==============================================================================
# Public functions
# ==============================================================================
func is_active() -> bool:
	return _state_active


func change_to_this_state(target: StateBase) -> void:
	if target == self:
		return
	
	# Find nearest ancestor
	var common_ancestor := _find_common_ancestor(target)
	
	# Get exiting states
	var exit_list: Array[StateBase] = []
	var current: StateBase = self
	while current and current != common_ancestor:
		if current._state_active:
			exit_list.append(current)
		if current.get_parent() is StateBase:
			current = current.get_parent()
		else:
			current = null
	
	# Get entering states
	var enter_list: Array[StateBase] = []
	var next: StateBase = target
	while next and next != common_ancestor:
		enter_list.push_front(next)
		next = next.get_parent() if next.get_parent() is StateBase else null
	
	# Exit states in exit_list
	for state in exit_list:
		state._state_exit()
	
	# Enter states in enter_list
	for state in enter_list:
		# If parent is a compound change active state
		if state.get_parent() is CompoundState:
			state.get_parent()._change_active_state(state)
		
		if not state._state_active:
			state._state_enter()


func _find_common_ancestor(other: StateBase) -> StateBase:
	var self_ancestors: Array = []
	var current: Node = self
	while current:
		self_ancestors.append(current)
		current = current.get_parent() if current.get_parent() is StateBase else null
	
	var other_current: Node = other
	while other_current:
		if other_current in self_ancestors:
			return other_current
		other_current = other_current.get_parent() if other_current.get_parent() is StateBase else null
	
	return null
