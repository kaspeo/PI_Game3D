extends Camera3D

@export var spring_arm: Node3D
@export var lerp_power: float = 2.0
@export var ray_length := 10.0
@export var player_body: Node3D
@export var grab_force := 10.0
@export var release_force := 0.4

@onready var prompt: Label = $"../../../UI/Prompt"
@onready var grab_target: Node3D = $GrabTarget

var grabbed_body: RigidBody3D = null

func _process(delta: float) -> void:
	position = lerp(position, spring_arm.position, delta * lerp_power)

	var viewport = get_viewport()
	var screen_center = viewport.get_visible_rect().size / 2

	var ray_origin = project_ray_origin(screen_center)
	var ray_direction = project_ray_normal(screen_center)

	var space_state = get_world_3d().direct_space_state
	var ray_end = ray_origin + ray_direction * ray_length

	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = space_state.intersect_ray(query)
	
	if result:
		var collider = result.collider
		var hit_position = result.position
		var distance = player_body.global_position.distance_to(hit_position)
		if collider is Interactable and distance <= 1.5:
			prompt.text = collider.get_prompt()
			if Input.is_action_just_pressed(collider.prompt_input):
				collider.interact(owner)
		
		elif collider is RigidBody3D and grabbed_body == null and distance <= 3.0:
			prompt.text = "Podnieś przedmiot 
			[LPM] "
		
		else:
			prompt.text = ""  
	else:
		prompt.text = ""

	if Input.is_action_pressed("Grab"):
		if grabbed_body:
			var dir = grab_target.global_position - grabbed_body.global_position
			grabbed_body.linear_velocity = dir * grab_force
		elif result and result.collider is RigidBody3D:
			grabbed_body = result.collider
			await get_tree().create_timer(0.2).timeout
			if grabbed_body:
				grabbed_body.max_contacts_reported = 1
				grabbed_body.contact_monitor = true
	elif Input.is_action_just_released("Grab"):
		release()

func release():
	if grabbed_body:
		grabbed_body.max_contacts_reported = 0
		grabbed_body.contact_monitor = false
		grabbed_body.linear_velocity *= release_force
		grabbed_body = null
