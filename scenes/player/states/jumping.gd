@tool
extends PlayerAtomicState


func state_entered() -> void:
	player.velocity.y += player.jump_velocity


func physics_update(_delta: float) -> void:
	if player.velocity.y < 0.0:
		change_state("falling")
