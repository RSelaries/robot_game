@icon("res://addons/simple_state_machine/icons/StateBase.svg")
@tool @abstract
class_name StateBase
extends StateMachineBase


var state_name: String


var state_machine: StateMachine
var _state_active: bool = false


func _ready() -> void:
	_state_active = false
	state_name = _pascal_to_snake(name)


func _state_init(ste_mch_ref: StateMachine) -> void:
	# This Should init the state and its children states (if any)
	_state_active = false
	state_machine = ste_mch_ref
	state_machine._states.append(self)


func _state_enter() -> void:
	if _state_active: return # Can't enter twice
	_state_active = true
	state_entered()


func _state_exit() -> void:
	if not _state_active: return # Can't exit twice
	_state_active = false
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
## This function is called every frame (on _process).
func update(delta: float) -> void: pass
## This function is called every physics frame (on _physics_process).
func physics_update(delta: float) -> void: pass
## This function is called for every _unhandled_input.
func state_input(event: InputEvent) -> void: pass
## This function is called each time the state is entered.
func state_entered() -> void: pass # TODO: Call
## This function is called each time the state is exited.
func state_exited() -> void: pass # TODO: Call


# ==============================================================================
# Public functions
# ==============================================================================
func is_active() -> bool:
	return _state_active
