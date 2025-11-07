@tool
extends PlayerCompoundState


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		change_state("airborne")


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("player_movement_jump") and !player.disable_jump:
		change_state("jumping")
