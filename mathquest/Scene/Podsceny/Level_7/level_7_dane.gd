extends Control
@onready var aedit: TextEdit = $HBoxContainer/HBoxContainer2/aedit
@onready var bedit: TextEdit = $HBoxContainer/HBoxContainer/bedit
@onready var result_label: Label = $HBoxContainer/ResultLabel


var correct_code_a := "-x + 3"
var correct_code_b := "-2x + 9"
var task_done := false


func _on_check_button_pressed() -> void:
	var entered_code_a = aedit.text.strip_edges().replace(" ", "")
	var entered_code_b = bedit.text.strip_edges().replace(" ", "")

	var correct_a = correct_code_a.replace(" ", "")
	var correct_b = correct_code_b.replace(" ", "")

	var a_ok = entered_code_a == correct_a
	var b_ok = entered_code_b == correct_b
	
	if a_ok and b_ok:
		result_label.text = "✅ Poprawnie! Zadanie ukończone."
		Global.get_ui().ustaw_misje("Interpolacja Lagrange'a", true)
		task_done = true
	else:
		var msg = "❌ Kod nadal zawiera błędy:\n"
		if not a_ok:
			msg += "- Podpunkt a) niepoprawny.\n"
		if not b_ok:
			msg += "- Podpunkt b) niepoprawny.\n"
		result_label.text = msg




func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	get_tree().paused = false
	visible = false
