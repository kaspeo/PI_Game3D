extends Control

signal level2_1_completed

@onready var input_a: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainerA/InputA
@onready var input_b: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainerB/InputB
@onready var output: Label = $MarginContainer/VBoxContainer/HBoxContainer4/Wynik
@onready var results_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer4/RichTextLabel
@onready var graph: Panel = $MarginContainer/VBoxContainer/PanelContainer/Graph

var a: float
var b: float
var x: float
var has_point := false
var iteration_count := 0
var max_iterations := 50
var tolerance := 0.001

func f(v: float) -> float:
	return sin(pow(v, 2) - v + (1.0 / 3.0)) + (v / 2.0)

func _on_oblicz_pressed() -> void:
	iteration_count = 0
	
	a = input_a.text.to_float()
	b = input_b.text.to_float()

	if a >= b:
		output.text = "❌ Nieprawidłowy przedział (a >= b)"
		results_label.text = ""
		return

	if f(a) * f(b) > 0:
		output.text = "❌ Zły przedział (f(a)*f(b) > 0)"
		results_label.text = ""
		return

	x = (a * f(b) - b * f(a)) / (f(b) - f(a))
	output.text = "Pierwszy punkt x = %.4f" % x
	has_point = true

	results_label.text = calculate_iterations(a, b)
	update_graph()

func _on_przedzial_a_pressed() -> void:
	_update_interval(true)

func _on_przedzial_b_pressed() -> void:
	_update_interval(false)

func _update_interval(use_left: bool) -> void:
	if not has_point:
		output.text = "Najpierw oblicz punkt!"
		return

	if abs(f(x)) < tolerance:
		output.text = "🎉 Rozwiązanie już znalezione: x = %.4f" % x
		return

	if iteration_count >= max_iterations:
		output.text = "⚠️ Osiągnięto maksymalną liczbę iteracji"
		return

	var fa = f(a)
	var fb = f(b)
	var fx = f(x)

	if use_left:
		if fa * fx < 0:
			b = x
			fb = fx
			output.text = "✅ Dobry wybór: przedział [a, x]"
			iteration_count += 1
		else:
			output.text = "❌ Zły wybór: przedział [a, x] - brak pierwiastka w tym przedziale"
			return
	else:
		if fx * fb < 0:
			a = x
			fa = fx
			output.text = "✅ Dobry wybór: przedział [x, b]"
			iteration_count += 1
		else:
			output.text = "❌ Zły wybór: przedział [x, b] - brak pierwiastka w tym przedziale"
			return

	x = (a * fb - b * fa) / (fb - fa)
	
	input_a.text = "%.4f" % a
	input_b.text = "%.4f" % b

	if abs(f(x)) < tolerance:
		output.text += "🎉 Znalazłeś rozwiązanie: x = %.4f (iteracja: %d)" % [x, iteration_count]
		emit_signal("level2_1_completed")

	results_label.text = calculate_iterations(a, b)
	update_graph()

func calculate_iterations(a: float, b: float) -> String:
	var fa = f(a)
	var fb = f(b)
	var output := "Iteracje Reguly Falsi:\n"
	output += "[code]      a         b         x        f(x)     Iteracja\n"
	
	var current_a = a
	var current_b = b
	var current_fa = fa
	var current_fb = fb
	
	for i in range(iteration_count + 1):
		var x_val = (current_a * current_fb - current_b * current_fa) / (current_fb - current_fa)
		var fx = f(x_val)
		
		var marker = " "
		if i == iteration_count:
			marker = "▶" 
		
		output += "%s %2d   %8.4f  %8.4f  %8.4f  %8.4f\n" % [marker, i, current_a, current_b, x_val, fx]

		if i < iteration_count:
			if current_fa * fx < 0:
				current_b = x_val
				current_fb = fx
			else:
				current_a = x_val
				current_fa = fx

	return output

func update_graph() -> void:
	if not graph:
		return
	graph.a = a
	graph.b = b
	graph.x = x
	graph.f = Callable(self, "f")
	graph.queue_redraw()

func _on_exit_pressed() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
