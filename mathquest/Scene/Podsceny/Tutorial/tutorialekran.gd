extends Control

signal OK(correct: bool)



func _on_button_exit_pressed() -> void:
	_close_ekran()

func _close_ekran() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.can_move = true


func _on_potwierdz_pressed() -> void:
	emit_signal("OK", true)
	_close_ekran()
