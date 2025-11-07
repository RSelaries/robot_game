class_name Player
extends CharacterBody3D


@export_group("Movement Settings")
@export var disable_movements: bool = false
@export var base_speed: float = 5.0
@export var sprint_speed_add: float = 3.0
@export var jump_velocity: float = 4.5
@export var acceleration_speed: float = 0.6
@export var deceleration_speed: float = 0.6

@export_group("References")
@export var player_mesh: Node3D


var input_dir: Vector2
var movement_dir: Vector2
var sprint_speed_modifier: float


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Calculate the total speed base on the speed modifiers
	# (sprint, crouch, jump etc ...)
	var total_speed: float = base_speed + sprint_speed_add
	
	# Calculate input direction
	var direction := _get_input_dir()
	
	# Rotate the mesh based on the input direction
	_rotate_mesh()
	
	# Apply the velocity based on the direction of input and the
	# calculated speed
	_apply_direction_to_velocity(direction, total_speed)
	
	move_and_slide()


func _get_input_dir() -> Vector3:
	input_dir = Input.get_vector(
		"player_movement_left", "player_movement_right",
		"player_movement_up", "player_movement_down"
	)
	var vec3_input_dir := Vector3(input_dir.x, 0, input_dir.y)
	return (transform.basis * vec3_input_dir).normalized()


func _rotate_mesh() -> void:
	if input_dir != Vector2.ZERO:
		movement_dir = input_dir
	
	var angle := -movement_dir.angle() + (PI / 2.0)
	player_mesh.rotation.y = angle


func _apply_direction_to_velocity(direction: Vector3, total_speed: float) -> void:
	if direction:
		var target_speed_x := direction.x * total_speed
		velocity.x = move_toward(velocity.x, target_speed_x, acceleration_speed)
		var target_speed_z := direction.z * total_speed
		velocity.z = move_toward(velocity.z, target_speed_z, acceleration_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
		velocity.z = move_toward(velocity.z, 0, deceleration_speed)
	
