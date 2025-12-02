extends Control

signal interpolation_solved

@onready var aedit: TextEdit = $MarginContainer/HBoxContainer/HBoxContainer2/aedit
@onready var bedit: TextEdit = $MarginContainer/HBoxContainer/HBoxContainer/bedit
@onready var result_label: Label = $MarginContainer/HBoxContainer/ResultLabel

var correct_answers_a = ["-x+3", "-1x+3", "3-x"]
var correct_answers_b = ["-2x+9", "9-2x"]
var task_done := false

func _on_check_button_pressed() -> void:
	if task_done:
		return

	var entered_code_a = aedit.text.strip_edges().replace(" ", "")
	var entered_code_b = bedit.text.strip_edges().replace(" ", "")

	var a_ok = entered_code_a in correct_answers_a
	var b_ok = entered_code_b in correct_answers_b
	
	if a_ok and b_ok:
		result_label.text = "✅ Poprawnie! Zadanie ukończone."
		result_label.add_theme_color_override("font_color", Color.GREEN)
		task_done = true
		interpolation_solved.emit()
		aedit.editable = false
		bedit.editable = false
	else:
		var msg = "❌ Kod nadal zawiera błędy:\n"
		if not a_ok:
			msg += "- Podpunkt a) niepoprawny.\n"
		if not b_ok:
			msg += "- Podpunkt b) niepoprawny.\n"
		result_label.text = msg
		result_label.add_theme_color_override("font_color", Color.RED)

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	get_tree().paused = false
	visible = false
