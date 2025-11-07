@tool
extends PlayerAtomicState


func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("player_movement_sprint"):
		change_state("sprinting")
