extends Node3D

var computers_done = 0
@onready var misja: AcceptDialog = $Dialogi/Misja
var popup_shown := false
const LEVEL_5 = "res://Scene/Level_5.tscn"
@onready var level_4_1: Control = $MisjaLevel4/Level4_1
@onready var wyjscie: Node3D = $wyjscie/Enter/Wyjscie

var solved_functions = {}

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level = 4
	misja.visible = false
	level_4_1.connect("level_4_1_completed", Callable(self, "register_solved_function"))

func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż zadanie na dwóch komputerach", false)

func register_solved_function(function_name: String) -> void:
	if not solved_functions.has(function_name):
		solved_functions[function_name] = true
		computers_done = solved_functions.size()
		update_mission_status()

func update_mission_status() -> void:
	if computers_done == 1:
		Global.get_ui().ustaw_misje("1/2 komputery naprawione", true)
		wyjscie.open_door()

func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_5)
		get_tree().change_scene_to_packed(new_scene)
