@tool
class_name PlayerCompoundState
extends CompoundState


var player


func _ready() -> void:
	super()
	if state_machine is PlayerStateMachine:
		player = state_machine.player
