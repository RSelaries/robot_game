# Settings
@tool
extends Node


signal pixelisation_amount_changed(new_pxl_amount: int)


var pixelisation_amount: int = 3: set = _set_pixelisation_amount


func _set_pixelisation_amount(value: int) -> void:
	value = clamp(value, 1, 3)
	pixelisation_amount = value
	pixelisation_amount_changed.emit(value)
