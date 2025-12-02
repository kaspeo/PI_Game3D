extends Node3D


@onready var misja: AcceptDialog = $Dialogi/Misja
const LEVEL_2 = "res://Scene/level_2.tscn"

var popup_shown := false

func _ready() -> void:
	Global.current_level = 1


	
func show_misja_dialog() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	misja.popup_centered()
	misja.grab_focus()
	misja.connect("confirmed", Callable(self, "_on_misja_confirmed"))

func _on_misja_confirmed() -> void:
	misja.hide()
	
func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Przenieś skrzynki", false)


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_2)
		get_tree().change_scene_to_packed(new_scene)
