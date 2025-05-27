extends Node3D

@onready var start: AcceptDialog = $Dialogi/Start
@onready var misjashape: Area3D = $Door1/Misja
@onready var misja: AcceptDialog = $Dialogi/Misja

func _ready() -> void:
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
	show_misja_dialog()
	if Global.get_ui():
		Global.get_ui().ustaw_misje("Przenieś skrzynki", false)
