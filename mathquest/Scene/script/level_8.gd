extends Node3D

const LEVEL_9 = "res://Scene/Level_9.tscn"
@onready var start: AcceptDialog = $Dialogi/Start
@onready var misja: AcceptDialog = $Dialogi/Misja

var popup_shown := false

func _ready() -> void:
	misja.visible = false
	Global.current_level=8

func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_9)
		get_tree().change_scene_to_packed(new_scene)


func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż 2 różne funkcje w komputerze", false)
