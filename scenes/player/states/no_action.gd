@tool
extends PlayerAtomicState


func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("action_key_1"):
		change_state("action_key_1")
	if event.is_action_pressed("action_key_2"):
		change_state("action_key_2")
