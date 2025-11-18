extends Node3D

@onready var start: AcceptDialog = $Dialogi/Start
@onready var misja: AcceptDialog = $Dialogi/Misja
const LEVEL_2 = "res://Scene/level_2.tscn"

var popup_shown := false

func _ready() -> void:
	Global.current_level = 1
	show_start_dialog()

func show_start_dialog() -> void:
	start.popup_centered()
	start.grab_focus()
	start.connect("confirmed", Callable(self, "_on_start_confirmed"))

func _on_start_confirmed() -> void:
	start.hide()
	
func show_misja_dialog() -> void:
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
