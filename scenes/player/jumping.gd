@tool
extends PlayerCompoundState


func state_entered() -> void:
	player.velocity.y += player.jump_velocity
	if Input.is_action_pressed("player_movement_sprint"):
		print("changed to sprint_jumping")
		change_state("sprint_jumping")

func physics_update(_delta: float) -> void:
	if player.velocity.y < 0.0:
		change_state("falling")
