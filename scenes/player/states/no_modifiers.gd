@tool
extends PlayerAtomicState


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_movement_sprint"):
		change_state("sprint_modifier")
