@tool
extends PlayerAtomicState


func state_entered() -> void:
	player.sprint_speed_modifier = player.sprint_speed_add


func state_exited() -> void:
	player.sprint_speed_modifier = 0
