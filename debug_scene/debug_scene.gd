extends Control


@onready var state_machine: StateMachine = $MovementFSM


func _ready() -> void:
	Dialogic.start("uid://c1flrwbmyas8i")
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_key_1"):
		state_machine.change_state("sprinting")
