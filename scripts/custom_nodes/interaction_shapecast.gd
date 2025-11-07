class_name InteractionShapeCast3D
extends ShapeCast3D


@export var multiple_interaction: bool = false


var interactable_components: Array[Node3D] = []


func _physics_process(_delta: float) -> void:
	interactable_components.clear()
	
	if not is_colliding(): return
	
	# If multiple interactions
	if multiple_interaction:
		for i in get_collision_count():
			var interactable := get_collider(i)
			interactable_components.append(interactable)
	
	# If single Interaction
	else:
		var interactable := get_collider(0)
		interactable_components.append(interactable)
