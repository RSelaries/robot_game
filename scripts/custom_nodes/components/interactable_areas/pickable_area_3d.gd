@tool
@icon("res://assets/icons/pickable_area_3d.svg")
class_name PickableArea3D
extends InteractableArea3D


enum PickableTypes {
	PARENT, ## This [PickableArea3D] will be used as the parent node (or the root node of the scene). The [param position] and [param rotation] of this Area will be modified if picked.
	CHILD, ## This [PickableArea3D] will be a child of a prent node. The [param position] and [param rotation] of its parent node will be modified.
	CHILD_OF_RIGID_BODY, ## This [PickableArea3D] will be a child of a [RigidBody3D]. The [param position] and [param rotation] of its parent [RigidBody3D] will be modified. While picked, the [RigidBody3D]'s physics will be disabled.
}

const WITH_TARGET := [PickableTypes.CHILD, PickableTypes.CHILD_OF_RIGID_BODY]


## Defines the behavior of this component.
@export var pickable_type: PickableTypes:
	set(value):
		pickable_type = value
		update_configuration_warnings()


var held: bool = false
var stored: bool = false
var player_target_held: Node3D
var player_target_stored: Node3D
var transform_target: RigidBody3D
var rot_offset: Vector3


func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	var player: Player = Global.player_ref
	player_target_held = player.held_box_collision
	player_target_stored = player.stored_box_pos
	
	
	if pickable_type in WITH_TARGET:
		var parent := get_parent_node_3d()
		if parent is RigidBody3D:
			transform_target = parent


func hold() -> void:
	held = true
	stored = false
	rot_offset = global_rotation -  player_target_held.global_rotation
	collision_layer = 0

func release() -> void:
	held = false
	stored = false
	collision_layer = 2


func store() -> void:
	held = false
	stored = true


func get_stored() -> void:
	held = true
	stored = false
	rot_offset = Vector3.ZERO
	collision_layer = 0


func _process(_delta: float) -> void:
	var target_position: Vector3
	var target_rotation: Vector3
	
	if held:
		target_position = player_target_held.global_position
		target_rotation = player_target_held.global_rotation + rot_offset
	
	elif stored:
		target_position = player_target_stored.global_position
		target_rotation = player_target_stored.global_rotation
	
	if held or stored:
		if pickable_type == PickableTypes.PARENT:
			_update_self_transform(target_position, target_rotation)
		else:
			_update_target_transform(target_position, target_rotation)


func _update_self_transform(pos: Vector3, rot: Vector3) -> void:
	global_position = pos
	global_rotation = rot


func _update_target_transform(pos: Vector3, rot: Vector3) -> void:
	transform_target.global_position = pos
	transform_target.global_rotation = rot


func disable_target_physics() -> void:
	if pickable_type == PickableTypes.CHILD_OF_RIGID_BODY:
		transform_target.freeze = true
		transform_target.add_collision_exception_with(Global.player_ref)


func enable_target_physics() -> void:
	if pickable_type == PickableTypes.CHILD_OF_RIGID_BODY:
		transform_target.freeze = false
		transform_target.remove_collision_exception_with(Global.player_ref)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if pickable_type == PickableTypes.CHILD_OF_RIGID_BODY:
		if get_parent() is not RigidBody3D:
			warnings.append("The direct parent of this PickableArea3D should be a RigidBody3D node.")
	
	return warnings
