extends RayCast3D
@onready var prompt: Label = $Prompt


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	prompt.text=""
	
	if is_colliding():
		var collider = get_collider()
		if collider is Interactable:
			print()
			prompt.text= collider.prompt_message
