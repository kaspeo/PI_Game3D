extends Node3D

@onready var start: AcceptDialog = $Dialogi/Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_start_dialog()

func show_start_dialog() -> void:
	start.popup_centered()
	start.grab_focus()
	start.connect("confirmed", Callable(self, "_on_start_confirmed"))

func _on_start_confirmed() -> void:
	start.hide()
