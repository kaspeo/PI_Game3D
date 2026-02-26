extends Control

class_name MonteCarloMethodComputer

var current_function: String = "exp(-x/2)*sin(3*x)*cos(2*x)"
var integration_limits: Array = [0.0, 3.0]
var num_points: int = 100
var exact_solution: float = 0.0
var target_accuracy: float = 0.97 
var optimal_range: Array = [800, 1200]
var current_points: Array = []

@onready var task_label: Label = $ColorRect/Panel/Vbox/TaskLabel
@onready var function_graph: ColorRect = $ColorRect/Panel/MonteCarlo
@onready var result_label: Label = $ColorRect/Panel/ResultLabel
@onready var points_value: Label = $ColorRect/Panel/Vbox/PointsValue
@onready var points_slider: HSlider = $ColorRect/Panel/Vbox/PointsSlider
@onready var check_button: Button = $ColorRect/Panel/Vbox/CheckButton
@onready var calculation_label: Label = $ColorRect/Panel/CalculationLabel

signal level_9_3_completed(function_name: String)

var is_solved := false

func _ready() -> void:
	setup_ui()
	exact_solution = calculate_exact_solution()
	generate_new_points()
	update_display()

func setup_ui():
	result_label.visible = false
	points_slider.min_value = 50
	points_slider.max_value = 2000
	points_slider.step = 50
	task_label.text = "METODA MONTE CARLO\nFunkcja: e^(-x/2)·sin(3x)·cos(2x) od 0 do 3\nDobierz odpowiednią liczbę punktów\n dla dokładności ~97%"
	update_points_display()

func _on_points_slider_value_changed(value: float):
	num_points = int(value)
	update_points_display()
	update_graph_display()

func update_display():
	update_graph_display()
	result_label.visible = false
	show_calculation_steps()

func update_graph_display():
	if function_graph:
		function_graph.set_problem(current_function, integration_limits)
		function_graph.set_monte_carlo_points(current_points)
		function_graph.queue_redraw()

func update_points_display():
	points_value.text = "Liczba punktów: %d" % num_points

func show_calculation_steps():
	var calculation_text = "Obliczenia Monte Carlo dla %d punktów:\n" % num_points
	var a = integration_limits[0]
	var b = integration_limits[1]
	var width = b - a
	var max_y = find_max_function_value()
	var min_y = find_min_function_value()
	var height = max_y - min_y
	calculation_text += "Przedział: [%.1f, %.1f] (szerokość = %.1f)\n" % [a, b, width]
	calculation_text += "Zakres wartości: [%.3f, %.3f] (wysokość = %.3f)\n" % [min_y, max_y, height]
	var rectangle_area = width * height
	calculation_text += "Pole prostokąta = %.1f × %.3f = %.3f\n" % [width, height, rectangle_area]
	var points_inside = count_points_inside()
	var points_shown = min(num_points, 10)
	calculation_text += "Przykładowe punkty (obecna próbka):\n"
	for i in range(points_shown):
		if i < current_points.size():
			var point = current_points[i]
			if point["inside"]:
				calculation_text += "Punkt %d: (%.3f, %.3f) - f(x)=%.3f ✓ wewnątrz\n" % [i+1, point["x"], point["y"], point["fx"]]
			else:
				calculation_text += "Punkt %d: (%.3f, %.3f) - f(x)=%.3f ✗ na zewnątrz\n" % [i+1, point["x"], point["y"], point["fx"]]
	if num_points > points_shown:
		calculation_text += "... (i %d innych punktów)\n" % (num_points - points_shown)
	var ratio = float(points_inside) / num_points
	var result = rectangle_area * ratio
	calculation_text += "Punkty wewnątrz: %d/%d = %.4f\n" % [points_inside, num_points, ratio]
	calculation_text += "Wynik = %.3f × %.4f = %.6f" % [rectangle_area, ratio, result]
	calculation_label.text = calculation_text

func _on_check_button_pressed() -> void:
	generate_new_points()
	show_detailed_calculation()

func generate_new_points():
	current_points.clear()
	var a = integration_limits[0]
	var b = integration_limits[1]
	var max_y = find_max_function_value()
	var min_y = find_min_function_value()
	for i in range(num_points):
		var x = randf_range(a, b)
		var y = randf_range(min_y, max_y)
		var fx = evaluate_function(x)
		var is_inside = (y >= 0 and y <= fx) or (y <= 0 and y >= fx)
		current_points.append({"x": x, "y": y, "fx": fx, "inside": is_inside})
	update_graph_display()
	show_calculation_steps()

func count_points_inside() -> int:
	var count = 0
	for point in current_points:
		if point["inside"]:
			count += 1
	return count

func show_detailed_calculation():
	var approx_result = calculate_from_current_points()
	var error = abs(approx_result - exact_solution)
	var accuracy = 1.0 - min(error / abs(exact_solution), 1.0)
	var percentage = accuracy * 100.0
	var result_text = "Wynik dla %d punktów:\n\n" % num_points
	result_text += "Przybliżony: %.8f\n" % approx_result
	result_text += "Dokładny:    %.8f\n" % exact_solution
	result_text += "Dokładność:  %.3f%%\n\n" % percentage

	if accuracy >= target_accuracy:
		result_text += "✅ Zadanie zaliczone!\n Osiągnięto wymaganą dokładność."
		result_label.modulate = Color.GREEN
		if not is_solved:
			is_solved = true
			emit_signal("level_9_3_completed", "monte_carlo")
	else:
		result_text += "❌ Za mała dokładność\n spróbuj z inną liczbą punktów."
		result_label.modulate = Color.RED

	result_label.text = result_text
	result_label.visible = true

func calculate_from_current_points() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var max_y = find_max_function_value()
	var min_y = find_min_function_value()
	var width = b - a
	var height = max_y - min_y
	var rectangle_area = width * height
	var points_inside = count_points_inside()
	var ratio = float(points_inside) / num_points
	return rectangle_area * ratio

func calculate_exact_solution() -> float:
	return high_precision_integration()

func high_precision_integration() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = 20000
	var h = (b - a) / n
	var result = evaluate_function(a) + evaluate_function(b)
	for i in range(1, n):
		var x = a + i * h
		var coefficient = 4.0 if i % 2 == 1 else 2.0
		result += coefficient * evaluate_function(x)
	return result * h / 3.0

func find_max_function_value() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var max_val = -INF
	for i in range(1000):
		var x = a + (b - a) * i / 1000.0
		var fx = evaluate_function(x)
		if fx > max_val:
			max_val = fx
	return max(0.1, max_val)

func find_min_function_value() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var min_val = INF
	for i in range(1000):
		var x = a + (b - a) * i / 1000.0
		var fx = evaluate_function(x)
		if fx < min_val:
			min_val = fx
	return min(-0.1, min_val)

func evaluate_function(x: float) -> float:
	return exp(-x/2.0) * sin(3.0 * x) * cos(2.0 * x)

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible = false
