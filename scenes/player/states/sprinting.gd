@tool
extends PlayerAtomicState


func state_entered() -> void:
	player.sprint_speed_modifier = player.sprint_speed_add


func state_exited() -> void:
	player.sprint_speed_modifier = 0


func state_input(event: InputEvent) -> void:
	if event.is_action_released("player_movement_sprint"):
		change_state("walking")
	if event.is_action_pressed("player_movement_jump"):
		get_viewport().set_input_as_handled()
		change_state("sprint_jumping")
