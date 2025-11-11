@tool
extends PlayerAtomicState


var releasing_object: PickableArea3D


func state_entered() -> void:
	releasing_object = player.held_object
	
	player.held_box_collision.disabled = true
	# Start lift box animation
	player.animation_tree.set(
		"parameters/Actions/BoxActions/put_box_down_1/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	player.animation_tree.animation_finished.connect(_on_lift_1_finished)
	player.animation_tree.set(
		"parameters/Actions/BoxActions/holding_box/blend_amount", 0
	)


# On box held
func _on_lift_1_finished(_param) -> void:
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_lift_1_finished)
	
	releasing_object.release()
	releasing_object.enable_target_physics()
	player.animation_tree.set(
		"parameters/Actions/BoxActions/put_box_down_2/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	
	# Connect new callable
	player.animation_tree.animation_finished.connect(_on_lift_2_finished)


func _on_lift_2_finished(_param) -> void:
	# Disconnect callable
	player.held_object = null
	player.animation_tree.animation_finished.disconnect(_on_lift_2_finished)
	change_state("no_action")


func state_exited() -> void:
	releasing_object = null
