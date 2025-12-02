extends Node3D

@onready var misja: AcceptDialog = $Dialogi/Misja
var popup_shown := false
const LEVEL_7 = "res://Scene/level_7.tscn"

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level=6


func show_misja_dialog() -> void:
	misja.popup_centered()
	misja.grab_focus()
	misja.connect("confirmed", Callable(self, "_on_misja_confirmed"))

func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Rozwiąż zadanie w komputerze", false)
		if not popup_shown:
			popup_shown = true
			show_misja_dialog()


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_7)
		get_tree().change_scene_to_packed(new_scene)
