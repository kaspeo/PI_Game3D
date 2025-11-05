extends CollisionObject3D

class_name Interactable





@onready var level_21: Control = $"../Level_21"
@onready var level_22: Control = $"../../MisjaKod2/Level_22"
@onready var level_3: Control = $"../Level3Wykres"
@onready var level_41: Control = $"../Level4_1"
@onready var level_42: Control = $"../../MisjaLevel4_2/Level4_2"
@onready var level_51: Control = $"../Level51"
@onready var level_52: Control = $"../../Drzwi2/Level52"
@onready var level_53: Control = $"../../Drzwi3/Level53"
@onready var level_61: Control = $"../Level61"
@onready var level_62: Control = $"../../Drzwi2/Level62"
@onready var level_63: Control = $"../../Drzwi3/Level63"
@onready var level_64: Control = $"../../Drzwi4/Level64"
@onready var level_7_kod: Control = $"../Level7_kod"
@onready var level_7_dane: Control = $"../../MisjaDane/Level7Dane"

var current_level = Global.current_level

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_input = "interact"

func get_prompt():
	if prompt_input == null or prompt_input == "":
		return prompt_message

	var key_name = ""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break	
	return prompt_message + "\n[" + key_name + "]"


func interact(body):
	if name =="Level_2_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_21.visible = true
	
	elif name =="Level_2_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_22.visible = true
		
	elif name =="Level_3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_3.visible = true
		
	elif name =="Level_4_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_41.visible = true
	
	elif name =="Level_4_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_42.visible = true
		
	elif name =="Level_5_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_51.visible = true
		
	elif name =="Level_5_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_52.visible = true
		
	elif name =="Level_5_3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_53.visible = true
		
	elif name =="Level_6_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_61.visible = true
	
	elif name =="Level_6_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_62.visible = true
		
	elif name =="Level_6_3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_63.visible = true
		
	elif name =="Level_6_4":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_64.visible = true	
		
	elif name =="Level_7_kod":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_7_kod.visible = true	
		
	elif name =="Level_7_dane":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move= false
		level_7_dane.visible = true	

	else:
		emit_signal("interacted", body)
