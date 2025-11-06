@tool
extends Control


@onready var test_button: Button = %TestButton


func _ready() -> void:
	test_button.pressed.connect(_on_test_button_pressed)


func _on_test_button_pressed() -> void:
	print("Test button pressed !")
