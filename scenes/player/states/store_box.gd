@tool
extends PlayerAtomicState


var object_to_store: PickableArea3D


func state_entered() -> void:
	object_to_store = player.held_object
	player.animation_tree.set(
		"parameters/Actions/BoxActions/store_box_1/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	player.animation_tree.set(
		"parameters/Actions/BoxActions/holding_box/blend_amount", 0.0
	)
	player.animation_tree.animation_finished.connect(_on_store_1_finished)


# On box stored
func _on_store_1_finished(_param) -> void:
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_store_1_finished)
	
	player.held_box_collision.disabled = true
	player.held_object = null
	player.stored_object = object_to_store
	object_to_store.store()
	
	player.animation_tree.set(
		"parameters/Actions/BoxActions/store_box_2/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	
	# Connect new callable
	player.animation_tree.animation_finished.connect(_on_store_2_finished)


func _on_store_2_finished(_param) -> void:
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_store_2_finished)
	change_state("no_action")


func state_exited() -> void:
	object_to_store = null
