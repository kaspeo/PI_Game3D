extends Control

signal answered(correct: bool)

var current_question: Dictionary
@onready var label_error: Label = $Panel/VBoxContainer/LabelError
@onready var question_lab: Label = $Panel/VBoxContainer/QuestionLab
@onready var buttona: Button = $Panel/VBoxContainer/VBoxContainer/GridContainer/ButtonA
@onready var buttonb: Button = $Panel/VBoxContainer/VBoxContainer/GridContainer/ButtonB
@onready var buttonc: Button = $Panel/VBoxContainer/VBoxContainer/GridContainer/ButtonC
@onready var buttond: Button = $Panel/VBoxContainer/VBoxContainer/GridContainer/ButtonD
@onready var label: Label = $Panel/VBoxContainer/QuestionLab

func set_question(q: Dictionary) -> void:
	current_question = q
	label.text = q["text"]
	buttona.text = "A: " + q["choices"][0]
	buttonb.text = "B: " + q["choices"][1]
	buttonc.text = "C: " + q["choices"][2]
	buttond.text = "D: " + q["choices"][3]

func _on_button_a_pressed() -> void:
	emit_signal("answered", 0 == current_question["correct"])
	_close_quiz()

func _on_button_b_pressed() -> void:
	emit_signal("answered", 1 == current_question["correct"])
	_close_quiz()

func _on_button_c_pressed() -> void:
	emit_signal("answered", 2 == current_question["correct"])
	_close_quiz()

func _on_button_d_pressed() -> void:
	emit_signal("answered", 3 == current_question["correct"])
	_close_quiz()

func _on_button_exit_pressed() -> void:
	_close_quiz()

func _close_quiz() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.can_move = true
