extends CollisionObject3D
class_name Interactable

@onready var level_2_kod: Control   = get_node_or_null("../../Level2Kod")
@onready var level_2_dane: Control  = get_node_or_null("../../Level2Dane")
@onready var level_3_wykres: Control = get_node_or_null("../../Level3Wykres")
@onready var level_42: Control      = get_node_or_null("../../Drzwi2/Level42")
@onready var level_41: Control      = get_node_or_null("../Level41")
@onready var level_43: Control      = get_node_or_null("../../Drzwi3/Level43")
@onready var level_51: Control      = get_node_or_null("../Level5_1")
@onready var level_52: Control      = get_node_or_null("../../Drzwi2/Level52")
@onready var level_53: Control      = get_node_or_null("../../Drzwi3/Level53")
@onready var level_54: Control      = get_node_or_null("../../Drzwi4/Level54")
@onready var level_71: Control      = get_node_or_null("../../Level_71")


var current_level = Global.current_level

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
		Global.can_move = false
	elif name =="Ekran2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		level_2_dane.visible = true
		Global.can_move = false
		
	elif name =="Ekran3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
		level_3_wykres.visible = true
		Global.can_move = false
		
	elif name =="Ekran4":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_41.visible = true
		Global.can_move = false
	
	elif name =="Ekran5":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_42.visible = true
		Global.can_move = false
	
	elif name =="Ekran6":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		level_43.visible = true
		Global.can_move = false
		
	else:
		emit_signal("interacted", body)
