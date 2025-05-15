extends Node3D


@onready var start: AcceptDialog = $Dialogi/Start
@onready var sterowanie: AcceptDialog = $Dialogi/Sterowanie
@onready var drzwi: AcceptDialog = $Dialogi/Drzwi
@onready var misja: AcceptDialog = $Dialogi/Misja

@onready var arrow_anim: AnimationPlayer = $Misja1/Arrow/AnimationPlayer


func _ready() -> void:
	show_start_dialog()
	arrow_anim.play("MoveUpDown")

func show_start_dialog() -> void:
	start.popup_centered()
	start.grab_focus()
	start.connect("confirmed", Callable(self, "_on_start_confirmed"))

func _on_start_confirmed() -> void:
	start.hide()
	show_sterowanie_dialog()

func show_sterowanie_dialog() -> void:
	sterowanie.popup_centered()
	sterowanie.grab_focus()
	sterowanie.connect("confirmed", Callable(self, "_on_sterowanie_confirmed"))

func _on_sterowanie_confirmed() -> void:
	sterowanie.hide()

func show_drzwi_dialog() -> void:
	drzwi.popup_centered()
	drzwi.grab_focus()
	drzwi.connect("confirmed", Callable(self, "_on_drzwi_confirmed"))

func _on_drzwi_confirmed() -> void:
	drzwi.hide()
	
func _on_door_area_body_entered(body: Node3D) -> void:
	show_drzwi_dialog()
	
func _on_koniec_body_entered(body: Node3D) -> void:
	call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://UI/KoniecPoziomu/KoniecTutorial.tscn")

func _on_misja_confirmed() -> void:
	misja.hide()

func show_misja_dialog() -> void:
	misja.popup_centered()
	misja.grab_focus()
	misja.connect("confirmed", Callable(self, "_on_misja_confirmed"))
	
func _on_area_popup_body_entered(body: Node3D) -> void:
	show_misja_dialog()
	if Global.get_ui():
		Global.get_ui().ustaw_misje("Przenieś skrzynię", false)
