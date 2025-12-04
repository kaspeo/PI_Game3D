extends Node3D

var computers_done = 0
@onready var misja: AcceptDialog = $Dialogi/Misja
@onready var level_4_1: Control = $MisjaLevel4/Level4_1
@onready var level_4_2: Control = $MisjaLevel4_2/Level4_2
@onready var wyjscie: Node3D = $wyjscie/Enter/Wyjscie
@onready var brama: GridMap = $Brama

const LEVEL_5 = "res://Scene/Level_5.tscn"
var popup_shown := false
var solved_functions = {}

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level = 4
	
	if level_4_1.has_signal("level_4_1_completed"):
		level_4_1.level_4_1_completed.connect(register_solved_function.bind("comp_1"))
	
	if level_4_2.has_signal("level_4_2_completed"):
		level_4_2.level_4_2_completed.connect(register_solved_function.bind("comp_2"))

func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.popup_centered()
			misja.grab_focus()
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż zadanie na dwóch komputerach", false)


func register_solved_function(computer_id: String, _unused_arg = "") -> void:
	if not solved_functions.has(computer_id):
		solved_functions[computer_id] = true
		update_mission_status()

func update_mission_status() -> void:
	computers_done = solved_functions.size()
	
	if computers_done == 1:
		if Global.get_ui():
			Global.get_ui().ustaw_misje("1/2 komputerów zrobione", false)
			
	elif computers_done >= 2:
		if Global.get_ui():
			Global.get_ui().ustaw_misje("2/2 komputerów zrobione ", true)
		brama.visible = false
		wyjscie.open_door()

func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		Progess.complete_level(4)
		var new_scene = load(LEVEL_5)
		get_tree().change_scene_to_packed(new_scene)
