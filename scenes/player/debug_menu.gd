extends CanvasLayer


func _ready() -> void:
	visible = false
	visibility_changed.connect(_visibility_changed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu_toggle"):
		visible = !visible


func _process(_d: float) -> void:
	if visible: Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _visibility_changed() -> void:
	if not visible: Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
