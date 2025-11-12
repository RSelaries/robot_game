extends CanvasLayer


func _ready() -> void:
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu_toggle"):
		visible = !visible
