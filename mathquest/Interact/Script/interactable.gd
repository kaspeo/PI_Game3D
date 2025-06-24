extends CollisionObject3D
class_name Interactable

@onready var level_2_kod: Control = $"../../Level2Kod"
@onready var level_2_dane: Control = $"../../Level2Dane"
@onready var level_3_wykres: Control = $"../../Level3Wykres"

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_input = "interact"
func get_prompt():
	var key_name=""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break	
	return prompt_message + "\n[" + key_name + "]"

func interact(body):
	if name == "Ekran1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		level_2_kod.visible = true
	elif name =="Ekran2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		level_2_dane.visible = true
		
	elif name =="Ekran3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		level_3_wykres.visible = true
		
	else:
		emit_signal("interacted", body)
	
