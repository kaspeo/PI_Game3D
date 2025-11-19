extends Node3D
@onready var sterowanie: AcceptDialog = $Dialogi/Sterowanie
@onready var drzwi: AcceptDialog = $Dialogi/Drzwi
@onready var misja: AcceptDialog = $Dialogi/Misja

@onready var arrow_anim: AnimationPlayer = $Misja1/Arrow/AnimationPlayer

var popup_door := false
var popup_misja := false
var sterowanie_shown := false

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	arrow_anim.play("MoveUpDown")
	
	if not sterowanie_shown:
		show_sterowanie_dialog()

func show_sterowanie_dialog() -> void:
	sterowanie.popup_centered()
	sterowanie.grab_focus()
	sterowanie_shown = true

func show_drzwi_dialog() -> void:
	if not popup_door:
		drzwi.popup_centered()
		drzwi.grab_focus()
		popup_door = true
	
func _on_door_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		show_drzwi_dialog()
	
func _on_koniec_body_entered(body: Node3D) -> void:
	call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://UI/KoniecPoziomu/KoniecTutorial.tscn")

func show_misja_dialog() -> void:
	if not popup_misja:
		misja.popup_centered()
		misja.grab_focus()
		popup_misja = true
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Przenieś skrzynię", false)
	
func _on_area_popup_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		show_misja_dialog()
