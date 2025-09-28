extends CollisionObject3D

class_name Interactable

@onready var level_3_wykres: Control = $"../../Level3Wykres"

@onready var level_2_kod: Control   = $"../../Level2Kod"
@onready var level_2_dane: Control  = $"../../Level2Dane"
@onready var level_42: Control      = $"../../Drzwi2/Level42"
@onready var level_41: Control      = $"../Level41"
@onready var level_43: Control      = $"../../Drzwi3/Level43"
@onready var level_51: Control = $"../Level5_1"
@onready var level_52: Control      = $"../../Drzwi2/Level52"
@onready var level_53: Control      = $"../../Drzwi3/Level53"
@onready var level_54: Control      = $"../../Drzwi4/Level54"
@onready var level_71: Control      = $"../../Level_71"


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
		if current_level==2:
			get_tree().paused = true
			Global.can_move= false
			level_2_kod.visible = true
		elif current_level==5:
			Global.can_move= false
			level_51.visible = true
			
	elif name =="Ekran2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if current_level==2:
			get_tree().paused = true
			Global.can_move= false
			level_2_dane.visible = true
		elif current_level==5:
			Global.can_move= false
			level_52.visible = true
			
	elif name =="Ekran3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if current_level==3:
			get_tree().paused = true
			Global.can_move= false
			level_3_wykres.visible = true
			
		elif current_level==5:
			Global.can_move= false
			level_53.visible = true
			
		elif current_level==7:
			Global.can_move= false
			level_71.visible = true
			
	elif name =="Ekran4":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if current_level==4:
			Global.can_move= false
			level_41.visible = true
		elif current_level==5:
			Global.can_move= false
			level_54.visible = true

	elif name =="Ekran5":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if current_level==4:
			Global.can_move= false
			level_42.visible = true

	elif name =="Ekran6":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if current_level==4:
			Global.can_move= false
			level_42.visible = true
	else:
		emit_signal("interacted", body)
