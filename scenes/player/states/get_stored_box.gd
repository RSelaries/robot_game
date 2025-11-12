@tool
extends PlayerAtomicState


var object_to_hold: PickableArea3D


func state_entered() -> void:
	object_to_hold = player.stored_object
	player.animation_tree.set(
		"parameters/Actions/BoxActions/get_stored_box_1/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	player.animation_tree.set(
		"parameters/Actions/BoxActions/holding_box/blend_amount", 1.0
	)
	player.animation_tree.animation_finished.connect(_on_get_stored_1_finished)


# On box stored
func _on_get_stored_1_finished(anim_name: String) -> void:
	if anim_name != "GetStoredBox1": return
	
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_get_stored_1_finished)
	
	player.stored_object = null
	player.held_object = object_to_hold
	object_to_hold.get_stored()
	
	player.animation_tree.set(
		"parameters/Actions/BoxActions/get_stored_box_2/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	
	# Connect new callable
	player.animation_tree.animation_finished.connect(_on_get_stored_2_finished)


func _on_get_stored_2_finished(anim_name: String) -> void:
	if anim_name != "GetStoredBox1": return
	
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_get_stored_2_finished)
	player.held_box_collision.disabled = false
	change_state("no_action")


func state_exited() -> void:
	object_to_hold = null
