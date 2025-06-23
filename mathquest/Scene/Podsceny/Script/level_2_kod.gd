extends Control
@onready var level_2_kod: Control = $"."

@onready var code_edit: TextEdit = $HBoxContainer/CodeEdit
@onready var result_label: Label = $HBoxContainer/ResultLabel

var correct_code := "L(x) = f0*(x - x1)/(x0 - x1) + f1*(x - x0)/(x1 - x0)"
var task_done := false

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	level_2_kod.visible = false

func _on_check_button_pressed() -> void:
	var entered_code = code_edit.text.strip_edges()
	if entered_code == correct_code:
		result_label.text = "✅ Poprawnie! Zadanie ukończone."
		Global.get_ui().ustaw_misje("Napraw komputer", true)
		task_done = true
		Global.get_ui().ustaw_misje("Interpolacja Lagrange'a", false)
	else:
		result_label.text = "❌ Kod nadal zawiera błąd."
