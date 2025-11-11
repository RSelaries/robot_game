@tool
extends PlayerAtomicState


var int_comp: PickableArea3D


func state_entered() -> void:
	var player_shapecast: ShapeCast3D = player.interaction_shapecast
	int_comp = player_shapecast.interactable_component
	player.held_object = int_comp
	int_comp.disable_target_physics()
	
	# Start lift box animation
	player.animation_tree.set(
		"parameters/Actions/BoxActions/lift_box_1/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	player.animation_tree.animation_finished.connect(_on_lift_1_finished)
	player.animation_tree.set(
		"parameters/Actions/BoxActions/holding_box/blend_amount", 1.0
	)


# On box held
func _on_lift_1_finished(_param) -> void:
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_lift_1_finished)
	
	int_comp.hold()
	player.animation_tree.set(
		"parameters/Actions/BoxActions/lift_box_2/request",
		AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	)
	
	# Connect new callable
	player.animation_tree.animation_finished.connect(_on_lift_2_finished)


func _on_lift_2_finished(_param) -> void:
	# Disconnect callable
	player.animation_tree.animation_finished.disconnect(_on_lift_2_finished)
	player.held_box_collision.disabled = false
	change_state("no_action")


func state_exited() -> void:
	int_comp = null
