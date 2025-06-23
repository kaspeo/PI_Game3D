extends Node3D

@onready var start: AcceptDialog = $Dialogi/Start
@onready var misja: AcceptDialog = $Dialogi/Misja


func show_start_dialog() -> void:
	start.popup_centered()
	start.grab_focus()
	start.connect("confirmed", Callable(self, "_on_start_confirmed"))

func _on_start_confirmed() -> void:
	show_misja_dialog()
	if Global.get_ui():
		Global.get_ui().ustaw_misje("Napraw komputer", false)

func show_misja_dialog() -> void:
	misja.popup_centered()
	misja.grab_focus()
	misja.connect("confirmed", Callable(self, "_on_misja_confirmed"))

func _on_area_3d_body_entered(body: Node3D) -> void:
	show_start_dialog()
	
