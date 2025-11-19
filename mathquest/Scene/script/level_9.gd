extends Node3D

var popup_shown := false
var computers_done = 0
const LEVEL_10 = "res://Scene/Level_10.tscn"
@onready var misja: AcceptDialog = $Dialogi/Misja
@onready var level_91: RectangleMethodComputer = $Zadania/Level_9_1/Level91
@onready var level_92: SimpsonMethodComputer = $Zadania/Level_9_2/Level92
@onready var level_93: MonteCarloMethodComputer = $Zadania/Level_9_3/Level93
@onready var wyjscie: Node3D = $Wyjscie/Enter/door

var solved_functions = {}

func _ready() -> void:
	Global.current_level = 9
	misja.visible = false
	level_91.connect("level_9_1_completed", Callable(self, "register_solved_function"))
	level_92.connect("level_9_2_completed", Callable(self, "register_solved_function"))
	level_93.connect("level_9_3_completed", Callable(self, "register_solved_function"))


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_10)
		get_tree().change_scene_to_packed(new_scene)


func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż zadanie na trzech komputerach", false)
				
func register_solved_function(function_name: String) -> void:
	if not solved_functions.has(function_name):
		solved_functions[function_name] = true
		computers_done = solved_functions.size()
		update_mission_status()

func update_mission_status() -> void:
	if computers_done == 1:
		Global.get_ui().ustaw_misje("1/3 generatory naprawione", false)
	elif computers_done == 2:
		Global.get_ui().ustaw_misje("2/3 generatory naprawione", false)
	elif computers_done == 3:
		Global.get_ui().ustaw_misje("Wszystkie generatory naprawione", true)
		wyjscie.open_door()
