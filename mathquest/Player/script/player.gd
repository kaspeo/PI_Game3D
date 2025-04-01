extends CharacterBody3D

@export var speed: float = 2.0
@export var jump_velocity: float = 2.5
@export var mouse_sensitivity: float = 0.01
@export var gravity: float = 9.8  # Dodana grawitacja
@onready var character: Node3D = $"character-male-e2"
@onready var camera_pivot: Node3D = $SpringArmPivot
@onready var camera: Camera3D = $SpringArmPivot/Camera3D
@onready var animation_player: AnimationPlayer = $"character-male-e2/AnimationPlayer"
@export var tilt_limit = deg_to_rad(75)

var direction = Vector3.ZERO

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()

	direction = direction.rotated(Vector3.UP, camera.global_rotation.y)

	# Obsługa ruchu
	if direction:
		direction *= speed
		velocity.x = move_toward(velocity.x, direction.x, delta * speed)
		velocity.z = move_toward(velocity.z, direction.z, delta * speed)

		if is_on_floor():
			if !animation_player.is_playing() or animation_player.current_animation != "Walk":
				animation_player.play("walk", 0.25)

			if velocity.length_squared() >= 0.1:
				var look_position = global_position + Vector3(velocity.x, 0, velocity.z)
				character.look_at(look_position, Vector3.UP, true)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * speed)
		velocity.z = move_toward(velocity.z, 0, delta * speed)

		if is_on_floor():
			if !animation_player.is_playing() or animation_player.current_animation != "Idle":
				animation_player.play("idle", 0.25)

	# Obsługa grawitacji
	if not is_on_floor():
		velocity.y -= gravity * delta  # Dodanie efektu spadania

	# Obsługa skoku
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	move_and_slide()
