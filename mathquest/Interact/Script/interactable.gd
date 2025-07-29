extends CollisionObject3D
class_name Interactable

@onready var level_2_kod: Control = $"../../Level2Kod"
@onready var level_2_dane: Control = $"../../Level2Dane"
@onready var level_3_wykres: Control = $"../../Level3Wykres"
@onready var level_42: Control = $"../../Drzwi2/Level42"
@onready var level_41: Control = $"../Level41"
@onready var level_43: Control = $"../../Drzwi3/Level43"

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
		
	elif name =="Ekran4":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_41.visible = true
	
	elif name =="Ekran5":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_42.visible = true
	
	elif name =="Ekran6":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_43.visible = true
		
	else:
		emit_signal("interacted", body)
	
