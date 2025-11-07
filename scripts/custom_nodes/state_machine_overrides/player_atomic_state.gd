@tool
class_name PlayerAtomicState
extends AtomicState


var player: Player


func _state_init(ste_mch_ref: StateMachine) -> void:
	super(ste_mch_ref)
	if ste_mch_ref is PlayerStateMachine:
		player = state_machine.player
