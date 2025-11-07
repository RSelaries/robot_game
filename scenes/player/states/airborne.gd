@tool
extends PlayerCompoundState


func physics_update(_delta: float) -> void:
	if player.is_on_floor():
		change_state("grounded")
