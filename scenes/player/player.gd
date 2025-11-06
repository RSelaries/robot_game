class_name Player
extends CharacterBody3D


@export_group("Movement Settings")
@export var disable_movements: bool = false
@export var base_speed: float = 5.0
@export var sprint_speed_add: float = 3.0
@export var jump_velocity: float = 4.5
@export var acceleration_speed: float = 0.6
@export var deceleration_speed: float = 0.6


var input_dir: Vector2
var sprint_speed_modifier: float


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var total_speed: float = base_speed + sprint_speed_add
	
	# Get the input direction and handle the movement/deceleration.
	input_dir = Input.get_vector(
		"player_movement_left", "player_movement_right",
		"player_movement_up", "player_movement_down"
	)
	var vec3_input_dir := Vector3(input_dir.x, 0, input_dir.y)
	var direction := (transform.basis * vec3_input_dir).normalized()
	
	if direction:
		var target_speed_x := direction.x * total_speed
		velocity.x = move_toward(velocity.x, target_speed_x, acceleration_speed)
		var target_speed_z := direction.z * total_speed
		velocity.z = move_toward(velocity.z, target_speed_z, acceleration_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
		velocity.z = move_toward(velocity.z, 0, deceleration_speed)
	
	move_and_slide()
