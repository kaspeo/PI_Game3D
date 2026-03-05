extends Control

signal level2_2_completed

@onready var input_a: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainerA/InputA
@onready var input_b: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainerB/InputB
@onready var output: Label = $MarginContainer/VBoxContainer/HBoxContainer4/Wynik
@onready var results_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer4/RichTextLabel
@onready var graph: Panel = $MarginContainer/VBoxContainer/PanelContainer/Graph
@onready var przedzal_ab: Button = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainer/PrzedzalAB

var a: float
var b: float
var x: float
var has_point := false
var iteration_count := 0
var max_iterations := 50
var tolerance := 0.00001
var wrong_interval_count := 0  



func f(v: float) -> float:
	return sin(4 * v) * cos(2 * v) + 0.2 * (v - 2.5) + 0.1 * sin(8 * v)

func _on_oblicz_pressed() -> void:
	iteration_count = 0
	wrong_interval_count = 0 
	przedzal_ab.visible = false
	
	a = input_a.text.to_float()
	b = input_b.text.to_float()

	if a >= b:
		output.text = "❌ Nieprawidłowy przedział (a >= b)"
		results_label.text = ""
		wrong_interval_count += 1
		_check_show_help_button()
		return

	if f(a) * f(b) > 0:
		output.text = "❌ Zły przedział (f(a)*f(b) > 0)"
		results_label.text = ""
		wrong_interval_count += 1
		_check_show_help_button()
		return

	wrong_interval_count = 0
	przedzal_ab.visible = false
	
	x = (a * f(b) - b * f(a)) / (f(b) - f(a))
	output.text = "Pierwszy punkt x = %.4f" % x
	has_point = true

	results_label.text = calculate_iterations(a, b)
	update_graph()

func _check_show_help_button():
	if wrong_interval_count >= 3:
		przedzal_ab.visible = true
		output.text += "\n💡 Potrzebujesz pomocy? Kliknij 'Znajdź przedział'"

func _on_przedzal_ab_pressed() -> void:
	find_good_interval()
	przedzal_ab.visible = false
	wrong_interval_count = 0

func find_good_interval() -> void:
	var good_intervals = [
		[1.2, 2.8], [1.0, 2.5], [0.8, 2.2],
		[1.5, 2.5], [1.3, 2.7], [0.9, 2.3]
	]
	
	for interval in good_intervals:
		var a_test = interval[0]
		var b_test = interval[1]
		var fa = f(a_test)
		var fb = f(b_test)
		
		if fa * fb < 0:
			input_a.text = "%.1f" % a_test
			input_b.text = "%.1f" % b_test
			output.text = "✅ Znaleziono dobry przedział: [%.1f, %.1f]\nKliknij 'Oblicz' aby kontynuować." % [a_test, b_test]
			return
	
	input_a.text = "1.2"
	input_b.text = "2.8"
	output.text = "✅ Ustawiono sprawdzony przedział [1.2, 2.8]\nKliknij 'Oblicz' aby kontynuować."

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
			output.text = "❌ Zły wybór: przedział [a, x] - brak pierwiastka"
			return
	else:
		if fx * fb < 0:
			a = x
			fa = fx
			output.text = "✅ Dobry wybór: przedział [x, b]"
			iteration_count += 1
		else:
			output.text = "❌ Zły wybór: przedział [x, b] - brak pierwiastka"
			return

	x = (a * fb - b * fa) / (fb - fa)
	
	input_a.text = "%.4f" % a
	input_b.text = "%.4f" % b

	if abs(f(x)) < tolerance:
		output.text += "\n🎉 Znalazłeś rozwiązanie: x = %.4f (iteracja: %d)" % [x, iteration_count]
		emit_signal("level2_2_completed")

	results_label.text = calculate_iterations(a, b)
	update_graph()

func calculate_iterations(a: float, b: float) -> String:
	var fa = f(a)
	var fb = f(b)
	var output := "Iteracje Reguły Falsi:\n"
	output += "Funkcja: f(x) = sin(4x)cos(2x) + 0.2(x - 2.5) + 0.1sin(8x)\n\n"
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
