@tool
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
var player_target_node: Node3D
var transform_target: RigidBody3D
var rot_offset: Vector3


func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return
	
	var player: Player = PlayerGlobal.player_ref
	player_target_node = player.held_box_collision
	
	if pickable_type in WITH_TARGET:
		var parent := get_parent_node_3d()
		if parent is RigidBody3D:
			transform_target = parent


func hold() -> void:
	held = true
	rot_offset = global_rotation -  player_target_node.global_rotation
	collision_layer = 0


func release() -> void:
	held = false
	collision_layer = 2


func _process(_delta: float) -> void:
	if held:
		var target_position := player_target_node.global_position
		var target_rotation := player_target_node.global_rotation + rot_offset
		
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
		transform_target.add_collision_exception_with(PlayerGlobal.player_ref)


func enable_target_physics() -> void:
	if pickable_type == PickableTypes.CHILD_OF_RIGID_BODY:
		transform_target.freeze = false
		transform_target.remove_collision_exception_with(PlayerGlobal.player_ref)


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if pickable_type == PickableTypes.CHILD_OF_RIGID_BODY:
		if get_parent() is not RigidBody3D:
			warnings.append("The direct parent of this PickableArea3D should be a RigidBody3D node.")
	
	return warnings
