@tool
class_name InteractionShapeCast3D
extends ShapeCast3D


@export var player: Player


var interactable_component: InteractableArea3D: set = _set_interactable_component


func _ready() -> void:
	collision_mask = 2
	collide_with_areas = true
	
	if Engine.is_editor_hint(): return
	player.property_watcher.watch_property(self, "interactable_component")


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if not is_colliding():
		if interactable_component:
			interactable_component = null
		return
	var interactable := get_collider(0)
	if interactable == interactable_component:
		return
	
	if interactable is InteractableArea3D:
		interactable_component = interactable
		return
	else:
		interactable_component = null


func _set_interactable_component(value) -> void:
	if interactable_component:
		interactable_component.focused = false
	interactable_component = value
	if value:
		interactable_component.focused = true
