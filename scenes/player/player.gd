class_name Player
extends CharacterBody3D


@export_group("Movement Settings")
@export var disable_movements: bool = false
@export var base_speed: float = 5.0
@export var sprint_speed_add: float = 3.0
@export var acceleration_speed: float = 0.6
@export var deceleration_speed: float = 0.6
@export_subgroup("Jump Settings")
@export var disable_jump: bool = false
@export var jump_velocity: float = 4.5

@export_group("References")
@export var player_mesh: Node3D
@export var property_watcher: PropertyWatcher
@export var held_box_collision: CollisionShape3D
@export var interaction_shapecast: InteractionShapeCast3D
@export var animation_tree: AnimationTree


var input_dir: Vector2
var movement_dir: Vector2
var sprint_speed_modifier: float = 0.0
var held_object: PickableArea3D = null
var stored_object: PickableArea3D = null
var velocity_length:
	get(): return velocity.length()


func _enter_tree() -> void:
	PlayerGlobal.player_ref = self


func _ready() -> void:
	_properties_to_watch()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Calculate the total speed base on the speed modifiers
	# (sprint, crouch, jump etc ...)
	var total_speed: float = base_speed + sprint_speed_modifier
	
	# Calculate input direction
	var direction := _get_input_dir()
	
	# Rotate the mesh based on the input direction
	_rotate_mesh()
	
	# Apply the velocity based on the direction of input and the
	# calculated speed
	_apply_direction_to_velocity(direction, total_speed)
	
	move_and_slide()


func _get_input_dir() -> Vector3:
	if disable_movements:
		input_dir = Vector2.ZERO
		return Vector3.ZERO

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
	var rot_y := player_mesh.rotation.y
	player_mesh.rotation.y = lerp_angle(rot_y, angle, acceleration_speed)


func _apply_direction_to_velocity(direction: Vector3, total_speed: float) -> void:
	if direction:
		var target_speed_x := direction.x * total_speed
		velocity.x = move_toward(velocity.x, target_speed_x, acceleration_speed)
		var target_speed_z := direction.z * total_speed
		velocity.z = move_toward(velocity.z, target_speed_z, acceleration_speed)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration_speed)
		velocity.z = move_toward(velocity.z, 0, deceleration_speed)


func _properties_to_watch() -> void:
	if not property_watcher: return
	
	property_watcher.watch_property(self, "velocity_length")
	property_watcher.watch_property(self, "position")
	property_watcher.watch_property(self, "held_object")
	property_watcher.watch_property(self, "stored_object")
