extends CharacterBody3D

@export var speed = 14
@export var fall_acceleration = 75
@export var jump_speed = 20
@onready var pivot: Node3D = $Pivot

@onready var camera_mount: Node3D = $Camera_mount

var sens_horizontal = 0.5

var sens_vertical = 0.5

var target_velocity = Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		#pivot.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y* sens_vertical))

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	# Pobieranie wejścia ruchu
	if Input.is_action_pressed("move_right"):
		$Pivot/Character/AnimationPlayer.play("Walk")
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		$Pivot/Character/AnimationPlayer.play("Walk")
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		$Pivot/Character/AnimationPlayer.play("Walk")
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		$Pivot/Character/AnimationPlayer.play("Walk")
		direction.z -= 1

	# Jeśli brak ruchu, odtwarzaj animację Idle
	if direction == Vector3.ZERO:
		$Pivot/Character/AnimationPlayer.play("Idle")

	# Przekształcenie kierunku ruchu na układ współrzędnych gracza
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		direction = global_transform.basis * direction  # Ruch względem kierunku gracza

	# Ustawianie prędkości na podstawie kierunku
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Skakanie
	if Input.is_action_just_pressed("jump") and is_on_floor():
		target_velocity.y = jump_speed

	# Grawitacja
	if not is_on_floor():
		target_velocity.y -= fall_acceleration * delta

	# Przesunięcie postaci
	velocity = target_velocity
	move_and_slide()
