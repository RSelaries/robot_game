@tool
extends PlayerCompoundState


func physics_update(_delta: float) -> void:
	if not player.is_on_floor():
		change_state("airborne")


func state_input(event: InputEvent) -> void:
	if player.disable_movements: return
	if player.disable_jump: return
	
	if event.is_action_pressed("player_movement_jump"):
		change_state("jumping")
