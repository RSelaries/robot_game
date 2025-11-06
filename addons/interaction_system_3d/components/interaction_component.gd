@tool
class_name InteractionComponent
extends Node


enum CastNodeType { RAYCAST_3D, SHAPECAST_3D }


@export var cast_node_type := CastNodeType.SHAPECAST_3D:
	set(value):
		cast_node_type = value
		notify_property_list_changed()
@export var interaction_raycast: RayCast3D
@export var interaction_shapecast: ShapeCast3D
@export var multiple_interaction: bool = false


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	var collider: Node
	if cast_node_type == CastNodeType.RAYCAST_3D and interaction_raycast:
		collider = interaction_raycast.get_collider()
	elif cast_node_type == CastNodeType.SHAPECAST_3D and interaction_shapecast:
		collider = interaction_shapecast.get_collider(0)
	
	if collider == null:
		return


func _validate_property(property: Dictionary) -> void:
	match property.name:
		"interaction_shapecast":
			if cast_node_type == CastNodeType.RAYCAST_3D:
				property.usage = PROPERTY_USAGE_NO_EDITOR
		"interaction_raycast":
			if cast_node_type == CastNodeType.SHAPECAST_3D:
				property.usage = PROPERTY_USAGE_NO_EDITOR
		"multiple_interaction":
			if cast_node_type == CastNodeType.RAYCAST_3D:
				property.usage = PROPERTY_USAGE_NO_EDITOR
