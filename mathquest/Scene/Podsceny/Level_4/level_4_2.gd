extends Control

@onready var misja_lab: Label = $PanelContainer/Panel/MisjaLab
@onready var result_lab: Label = $PanelContainer/Panel/ResultLab
@onready var obliczenia_lab: Label = $PanelContainer/Panel/VBoxContainer/CalcLab
@onready var wykres: GraphDrawer2 = $MarginContainer/Level4_2_wykres
@onready var button_a: Button = $PanelContainer/Panel/VBoxContainer/HBoxContainer/ButtonA
@onready var button_b: Button = $PanelContainer/Panel/VBoxContainer/HBoxContainer/ButtonB
@onready var button_c: Button = $PanelContainer/Panel/VBoxContainer/HBoxContainer/ButtonC
@onready var button_next = $PanelContainer/Panel/NextIter

signal level_4_2_completed

var iteration := 0
var x_current := 1.8
var f = func(x): return x*x*x - 2*x*x - 5*x + 6
var df = func(x): return 3*x*x - 4*x - 5
var correct_x_next := 0.0
var points := []
var task_completed := false

func _ready():
	if wykres and wykres is GraphDrawer2:
		wykres.function = f
		wykres.queue_redraw()
	await get_tree().process_frame
	_new_iteration()

func _new_iteration():
	if task_completed:
		return
	var fx = f.call(x_current)
	var dfx = df.call(x_current)
	correct_x_next = x_current - fx / dfx
	var iter_data = {"x": x_current, "fx": fx, "dfx": dfx, "x_new": correct_x_next}
	points.append(iter_data)
	if wykres and wykres is GraphDrawer2:
		wykres.iterations_data = points
		wykres.current_iteration = points.size() - 1
		wykres.queue_redraw()
	if abs(fx) < 0.0001:
		_complete_task()
		return
	if iteration >= 8:
		_complete_task()
		return
	iteration += 1
	var wrong1 = correct_x_next + randf_range(0.2, 0.5) * (1.0 if randi() % 2 == 0 else -1.0)
	var wrong2 = correct_x_next + randf_range(0.6, 1.0) * (1.0 if randi() % 2 == 0 else -1.0)
	var options = [correct_x_next, wrong1, wrong2]
	options.shuffle()
	button_a.text = "%.4f" % options[0]
	button_b.text = "%.4f" % options[1]
	button_c.text = "%.4f" % options[2]
	misja_lab.text = "Iteracja %d: Znajdź x%d\nAktualny x%d = %.4f" % [iteration, iteration, iteration-1, x_current]
	obliczenia_lab.text = "Wzór metody Newtona:\nxₙ₊₁ = xₙ - f(xₙ)/f'(xₙ)"
	result_lab.text = ""
	button_next.visible = false
	button_a.disabled = false
	button_b.disabled = false
	button_c.disabled = false

func _complete_task():
	task_completed = true
	var final_fx = f.call(correct_x_next)
	misja_lab.text = "🎉 Zadanie ukończone!"
	level_4_2_completed.emit("metoda_iteracji_2")
	obliczenia_lab.text = ""
	result_lab.text = "Znaleziono pierwiastek: x ≈ %.4f\nf(%.4f) = %.6f\nLiczba iteracji: %d" % [correct_x_next, correct_x_next, final_fx, iteration]
	button_a.visible = false
	button_b.visible = false
	button_c.visible = false
	button_next.visible = false
	if wykres and wykres is GraphDrawer2:
		wykres.queue_redraw()

func _check_answer(selected: float):
	if task_completed:
		return
	if abs(selected - correct_x_next) < 0.01:
		result_lab.text = "✅ Dobrze! x%d ≈ %.4f" % [iteration, correct_x_next]
		obliczenia_lab.text = "Wzór metody Newtona:\nxₙ₊₁ = xₙ - f(xₙ)/f'(xₙ)"
	else:
		result_lab.text = "❌ Źle! Poprawne: %.4f" % correct_x_next
		obliczenia_lab.text = "Wzór metody Newtona:\nxₙ₊₁ = xₙ - f(xₙ)/f'(xₙ)"
	button_a.disabled = true
	button_b.disabled = true
	button_c.disabled = true
	button_next.visible = true

func _on_button_a_pressed():
	_check_answer(float(button_a.text))

func _on_button_b_pressed():
	_check_answer(float(button_b.text))

func _on_button_c_pressed():
	_check_answer(float(button_c.text))

func _on_next_iter_pressed():
	if task_completed:
		return
	x_current = correct_x_next
	_new_iteration()

func _on_exit_pressed():
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
