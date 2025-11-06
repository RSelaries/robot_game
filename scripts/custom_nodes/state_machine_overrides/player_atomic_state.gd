@tool
class_name PlayerAtomicState
extends AtomicState


var player


func _ready() -> void:
	super()
	if state_machine is PlayerStateMachine:
		player = state_machine.player
