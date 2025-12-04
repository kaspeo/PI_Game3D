extends Node3D

var computers_done = 0
@onready var misja: AcceptDialog = $Dialogi/Misja
var popup_shown := false
@onready var start: AcceptDialog = $Dialogi/Start
@onready var level_3_wykres: Control = $MisjaKod/Level3Wykres
@onready var wyjscie: Node3D = $Wyjscie/Enter/Wyjscie
const LEVEL_4 = "res://Scene/Level_4.tscn"

var solved_functions = {}

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level = 3
	misja.visible = false
	level_3_wykres.connect("function_solved", Callable(self, "register_solved_function"))

func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż 2 różne funkcje w komputerze", false)


func register_solved_function(function_name: String) -> void:
	if not solved_functions.has(function_name):
		solved_functions[function_name] = true
		computers_done = solved_functions.size()
		update_mission_status()

func update_mission_status() -> void:
	if computers_done == 1:
		Global.get_ui().ustaw_misje("1/2 funkcji zrobione", false)
	elif computers_done >= 2:
		Global.get_ui().ustaw_misje("2/2 funkcji zrobione", true)
		wyjscie.open_door()

func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		Progess.complete_level(3)
		var new_scene = load(LEVEL_4)
		get_tree().change_scene_to_packed(new_scene)
