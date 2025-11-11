## Behave like [FollowComponent] but targets two nodes instead of one.
@tool
class_name FollowTwoComponents
extends FollowComponent


@export var secondary_follow_target: Node3D


func _process(_delta: float) -> void:
	if follow_target and secondary_follow_target and parent:
		if follow_position:
			var pos_1 := follow_target.global_position
			var pos_2 := secondary_follow_target.global_position
			var follow_pos := pos_1 + pos_2
			follow_pos /= 2.0
			parent.global_position = follow_pos
		if follow_rotation:
			var rot_1 := follow_target.global_rotation
			var rot_2 := secondary_follow_target.global_rotation
			var follow_rot := rot_1 + rot_2
			follow_rot /= 2.0
			follow_rot += offset_rot
			if !lock_rot_x:
				parent.global_rotation.x = follow_rot.x
			if !lock_rot_y:
				parent.global_rotation.y = follow_rot.y
			if !lock_rot_z:
				parent.global_rotation.z = follow_rot.z
