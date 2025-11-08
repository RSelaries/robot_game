@tool
extends PlayerAtomicState


func state_entered() -> void:
	change_state("no_action")
