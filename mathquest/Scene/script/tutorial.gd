extends Node3D
@onready var sterowanie: AcceptDialog = $Dialogi/Sterowanie
@onready var drzwi: AcceptDialog = $Dialogi/Drzwi
@onready var misja: AcceptDialog = $Dialogi/Misja
@onready var misja_2: AcceptDialog = $Dialogi/Misja2
@onready var ekran: Control = $Misja2/Tutorialekran
@onready var wyjscie: Node3D = $"Wyjscie/double-door"

@onready var arrow_anim: AnimationPlayer = $Misja1/Arrow/AnimationPlayer

var popup_door := false
var popup_misja := false
var popup_misja_2 := false
var sterowanie_shown := false
var skrzynka_gotowa := false

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	arrow_anim.play("MoveUpDown")
	ekran.connect("OK", Callable(self, "_on_ekran_potwierdzony"))
	drzwi.visible=false
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
			Global.get_ui().ustaw_misje("Przenieś skrzynię i wejdź do komputera", false)
	
func _on_area_popup_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		show_misja_dialog()

func _on_area_skrzynka_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Skrzynka":
		skrzynka_gotowa = true
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Wejdź do komputera", false)

		
func _on_ekran_potwierdzony(correct: bool) -> void:
	if skrzynka_gotowa:
		misja_done()

func misja_done() -> void:
	wyjscie.open_door()
	if Global.get_ui():
		Global.get_ui().ustaw_misje("Przenieś skrzynię i wejdź do komputera", true)


func _on_area_ekran_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_misja_2:
			misja_2.popup_centered()
			misja_2.grab_focus()
			popup_misja_2 = true
