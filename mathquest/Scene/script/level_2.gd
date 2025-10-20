extends Node3D

var computers_done = 0
@onready var misja: AcceptDialog = $Dialogi/Misja
var popup_shown := false
@onready var level_21: Control = $MisjaKod/Level_21
@onready var level_22: Control = $MisjaKod2/Level_22
@onready var wyjscie: Node3D = $Wyjscie
const LEVEL_3 = "res://Scene/Level_3.tscn"

func _ready() -> void:
	Global.current_level = 2
	misja.visible = false
	level_21.connect("level2_1_completed", Callable(self, "_on_scena_completed"))
	level_22.connect("level2_2_completed", Callable(self, "_on_scena_completed"))

func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż zadanie w komputerze", false)

func _on_scena_completed():
	computers_done += 1
	if computers_done == 1:
		Global.get_ui().ustaw_misje("1/2 komputerów zrobione", false)
	elif computers_done == 2:
		Global.get_ui().ustaw_misje("2/2 komputerów zrobione", true)
		wyjscie.open_door()


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_3)
		get_tree().change_scene_to_packed(new_scene)
