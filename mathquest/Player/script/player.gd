extends CharacterBody3D

@export var speed: float = 4.0
@export var acceleration: float = 10.0
@export var friction: float = 8.0
@export var jump_velocity: float = 4.0
@export var mouse_sensitivity: float = 0.01
@export var gravity: float = 15.0
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.2
@onready var character: Node3D = $"character-male-e2"
@onready var camera_pivot: Node3D = $SpringArmPivot
@onready var camera: Camera3D = $SpringArmPivot/SpringArm3D/Camera3D
@onready var animation_player: AnimationPlayer = $"character-male-e2/AnimationPlayer"

var direction = Vector3.ZERO
var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var move_direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	move_direction = move_direction.rotated(Vector3.UP, camera.global_rotation.y)

	if move_direction != Vector3.ZERO:
		var target_velocity = move_direction * speed
		velocity.x = lerp(velocity.x, target_velocity.x, acceleration * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, acceleration * delta)

		if is_on_floor():
			if !animation_player.is_playing() or animation_player.current_animation != "Walk":
				animation_player.play("walk", 0.2)

		var look_position = global_position + Vector3(velocity.x, 0, velocity.z)
		character.look_at(look_position, Vector3.UP, true)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)
		velocity.z = lerp(velocity.z, 0.0, friction * delta)

		if is_on_floor():
			if !animation_player.is_playing() or animation_player.current_animation != "Idle":
				animation_player.play("idle", 0.2)

	if is_on_floor():
		coyote_timer = coyote_time
	else:
		velocity.y -= gravity * delta
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time

	if coyote_timer > 0.0 and jump_buffer_timer > 0.0:
		velocity.y = jump_velocity
		coyote_timer = 0.0
		jump_buffer_timer = 0.0
	else:
		jump_buffer_timer -= delta

	move_and_slide()
