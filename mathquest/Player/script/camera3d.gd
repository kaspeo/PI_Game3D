extends Camera3D

@export var spring_arm: Node3D
@export var lerp_power: float = 2.0

@export var ray_length := 10.0
@export var player_body: Node3D

@onready var prompt: Label = $"../../../UI/Prompt"

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
		else:
			prompt.text = ""  
	else:
		prompt.text = ""  
