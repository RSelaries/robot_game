@tool
class_name InteractionShapeCast3D
extends ShapeCast3D


@export var multiple_interaction: bool = false


var interactable_component: InteractableArea3D: set = _set_interactable_component


func _ready() -> void:
	collision_mask = 2


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	if not is_colliding(): return
	
	var interactable := get_collider(0)
	if interactable is InteractableArea3D:
		interactable_component = interactable


func _set_interactable_component(value) -> void:
	if interactable_component:
		interactable_component.focused = false
	interactable_component = value
	interactable_component.focused = true
