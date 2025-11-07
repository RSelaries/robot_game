@tool
extends PlayerCompoundState


func state_entered() -> void:
	player.velocity.y += player.jump_velocity
