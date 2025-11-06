# GameMenu scene autoload
extends Node


@onready var menu_canvas_layer: CanvasLayer = %MenuCanvasLayer
@onready var animation_player: AnimationPlayer = %AnimationPlayer


var opened: bool = false: set = _set_opened


func _ready() -> void:
	menu_canvas_layer.visible = false
	opened = false
	#animation_player.play("RESET")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_menu"):
		opened = !opened


func _toggle_game_menu(value: bool) -> void:
	# Show menu
	if not menu_canvas_layer: return
	
	menu_canvas_layer.visible = value
	
	#if value:
		#animation_player.play("tv_shutdown", -1, -1, true)
	#else:
		#animation_player.play("tv_shutdown")


func _set_opened(value: bool) -> void:
	opened = value
	_toggle_game_menu(value)
