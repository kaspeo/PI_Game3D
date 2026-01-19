extends Node3D

var computers_done = 0
@onready var misja: AcceptDialog = $Dialogi/Misja
var popup_shown := false
const LEVEL_8 = "res://Scene/Level_8.tscn"
@onready var kod: Control = $MisjaKod/Level7_kod
@onready var dane: Control = $MisjaDane/Level7Dane
@onready var wyjscie : Node3D = $Wyjscie/Enter/door

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level = 7
	
	if kod.has_signal("interpolation_solved"):
		kod.interpolation_solved.connect(_on_scena_completed)

	if dane.has_signal("interpolation_solved"):
		dane.interpolation_solved.connect(_on_scena_completed)
		
	
func show_misja_dialog() -> void:
	misja.popup_centered()
	misja.grab_focus()


func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Napraw dwa komputery", false)
			popup_shown = true
			show_misja_dialog()


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		Progess.complete_level(7)
		var new_scene = load(LEVEL_8)
		get_tree().change_scene_to_packed(new_scene)

func _on_scena_completed():
	computers_done += 1
	if computers_done == 1:
		Global.get_ui().ustaw_misje("1/2 komputerów zrobione", false)
	elif computers_done == 2:
		Global.get_ui().ustaw_misje("2/2 komputerów zrobione", true)
		wyjscie.open_door()
