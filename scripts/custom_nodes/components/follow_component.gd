## This component should be attached to a Node3D as a child. The component
## will change its parent [param global_position] and [param global_rotation] to
## [param follow_target]'s [param global_position] and [param global_rotation].
@tool
class_name FollowComponent
extends Node


@export var follow_target: Node3D
@export var follow_position: bool = true
@export var follow_rotation: bool = true
@export var offset_rot: Vector3
@export var lock_rot_x: bool = false
@export var lock_rot_y: bool = false
@export var lock_rot_z: bool = false


var parent: Node3D


func _ready() -> void:
	if get_parent() is Node3D: parent = get_parent()

func _process(_delta: float) -> void:
	if follow_target and parent:
		if follow_position:
			parent.global_position = follow_target.global_position
		if follow_rotation:
			parent.global_rotation = follow_target.global_rotation + offset_rot
