@tool
extends PlayerAtomicState


func state_entered() -> void:
	player.sprint_speed_modifier = player.sprint_speed_add


func state_exited() -> void:
	player.sprint_speed_modifier = 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("player_movement_sprint"):
		change_state("no_modifier")
