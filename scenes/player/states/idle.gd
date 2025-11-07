@tool
extends PlayerAtomicState


func physics_update(_delta: float) -> void:
	var planar_velocity := Vector2(player.velocity.x, player.velocity.z)
	if planar_velocity.length() > 0.0:
		change_state("moving")
