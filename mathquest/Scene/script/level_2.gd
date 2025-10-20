extends Node3D

@onready var misja: AcceptDialog = $Dialogi/Misja
var popup_shown := false

func _ready() -> void:
	Global.current_level = 2
	misja.visible = false



func _on_misja_body_entered(body: Node3D) -> void:
	if Global.get_ui():
		Global.get_ui().ustaw_misje("Rozwiąż zadanie w komputerze", false)
	if not popup_shown:
		popup_shown = true
		misja.visible = true
