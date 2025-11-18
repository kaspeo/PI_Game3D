extends Control

class_name SimpsonMethodComputer

var current_function: String = "exp(-x/2)*sin(3*x)*cos(2*x)"  
var integration_limits: Array = [0.0, 3.0]   
var num_segments: int = 8
var exact_solution: float = 0.0
var target_accuracy: float = 0.995
var optimal_range: Array = [16, 20]

@onready var task_label: Label = $Panel/Vbox/TaskLabel
@onready var function_graph: ColorRect = $"Function Graph"
@onready var result_label: Label = $Panel/ResultLabel
@onready var segments_value: Label = $Panel/Vbox/SegmentsValue
@onready var segments_slider: HSlider = $Panel/Vbox/SegmentsSlider
@onready var check_button: Button = $Panel/Vbox/CheckButton
@onready var calculation_label: Label = $Panel/CalculationLabel

signal level_9_2_completed(function_name: String)

var is_solved := false

func _ready() -> void:
	setup_ui()
	exact_solution = calculate_exact_solution()
	update_display()

func setup_ui():
	result_label.visible = false
	
	segments_slider.min_value = 2
	segments_slider.max_value = 50
	segments_slider.step = 2
	
	task_label.text = "METODA SIMPSONA\nOblicz całkę funkcji e^(-x/2)·sin(3x)·cos(2x)\n od 0 do 3\n z dokładnością powyżej 99.9%"
	
	update_segments_display()

func _on_rect_count_slider_value_changed(value: float):
	num_segments = int(value)

	if num_segments % 2 != 0:
		num_segments += 1
	
	update_segments_display()
	update_display()

func update_display():
	visualize_method()
	result_label.visible = false
	show_calculation_steps()

func visualize_method():
	if function_graph:
		function_graph.set_problem(current_function, integration_limits)
		function_graph.update_visualization("simpson", num_segments)

func update_segments_display():
	segments_value.text = "Segmenty: %d" % num_segments

func show_calculation_steps():
	var calculation_text = "Obliczenia Simpsona dla %d segmentów:\n\n" % num_segments
	
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = num_segments
	var h = (b - a) / n
	
	calculation_text += "h = (%.1f - %.1f) / %d = %.4f\n\n" % [b, a, n, h]
	calculation_text += "Wzór: (h/3)×[f(x₀) + f(xₙ) + 4Σf(x nieparz) + 2Σf(x parz)]\n\n"
	
	var sum_odd = 0.0
	var sum_even = 0.0
	
	var points_shown = min(n, 5) 
	for i in range(1, points_shown):
		var x = a + i * h
		var fx = evaluate_function(x)
		if i % 2 == 1:
			sum_odd += fx
			calculation_text += "x%d = %.3f → f(x) = %.4f (nieparzyste)\n" % [i, x, fx]
		else:
			sum_even += fx
			calculation_text += "x%d = %.3f → f(x) = %.4f (parzyste)\n" % [i, x, fx]
	
	if n > points_shown:
		calculation_text += "... (i %d innych punktów)\n" % (n - points_shown)
		for i in range(points_shown, n):
			var x = a + i * h
			if i % 2 == 1:
				sum_odd += evaluate_function(x)
			else:
				sum_even += evaluate_function(x)
	
	calculation_text += "\nSuma nieparzyste: %.4f\n" % sum_odd
	calculation_text += "Suma parzyste:    %.4f\n" % sum_even
	
	var fa = evaluate_function(a)
	var fb = evaluate_function(b)
	var result = (h / 3.0) * (fa + fb + 4 * sum_odd + 2 * sum_even)
	
	calculation_text += "\nf(x₀) = f(%.1f) = %.4f\n" % [a, fa]
	calculation_text += "f(xₙ) = f(%.1f) = %.4f\n" % [b, fb]
	calculation_text += "Wynik = (%.4f/3) × (%.4f + %.4f + 4×%.4f + 2×%.4f) = %.6f" % [h, fa, fb, sum_odd, sum_even, result]
	
	calculation_label.text = calculation_text

func show_detailed_calculation():
	var approx_result = simpson_method(num_segments)
	var error = abs(approx_result - exact_solution)
	
	var accuracy = 0.0
	if exact_solution != 0:
		accuracy = 1.0 - min(error / abs(exact_solution), 1.0)
	else:
		accuracy = 1.0 - min(error, 1.0)
	
	var percentage = accuracy * 100
	
	var result_text = "Wynik dla %d segmentów:\n\n" % num_segments
	
	result_text += "Przybliżony: %.8f\n" % approx_result
	result_text += "Dokładny:    %.8f\n" % exact_solution
	result_text += "Dokładność:  %.3f%%\n\n" % percentage
	
	var is_high_accuracy = (accuracy >= target_accuracy)
	var is_optimal_range = (num_segments >= optimal_range[0] and num_segments <= optimal_range[1])
	
	if is_high_accuracy:
		if is_optimal_range:
			result_text += "✓ Idealnie! Odpowiednia liczba segmentów"
			result_label.modulate = Color.GREEN
			if not is_solved:
				is_solved = true
				emit_signal("level_9_2_completed", "simpson_method")
		elif num_segments < optimal_range[0]:
			result_text += "✓ Dokładność dobra,\n ale można użyć więcej segmentów\n dla optymalnej efektywności"
			result_label.modulate = Color.YELLOW
		else:
			result_text += "✓ Dokładność dobra,\n ale za dużo segmentów\n (nieefektywne)"
			result_label.modulate = Color.ORANGE
	else:
		if num_segments < optimal_range[0]:
			result_text += "✗ Za mało segmentów  zwiększ liczbę"
			result_label.modulate = Color.RED
		elif num_segments > optimal_range[1]:
			result_text += "✗ Za dużo segmentów zmniejsz liczbę"
			result_label.modulate = Color.ORANGE
		else:
			result_text += "✗ Spróbuj innych wartości"
			result_label.modulate = Color.RED
	
	result_label.text = result_text
	result_label.visible = true

func calculate_exact_solution() -> float:
	return high_precision_integration()

func high_precision_integration() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = 20000 
	var h = (b - a) / n
	var result = 0.0
	
	result = evaluate_function(a) + evaluate_function(b)
	
	for i in range(1, n):
		var x = a + i * h
		var coefficient = 4.0 if i % 2 == 1 else 2.0
		result += coefficient * evaluate_function(x)
	
	return result * h / 3.0

func simpson_method(n: int) -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var h = (b - a) / n
	var result = evaluate_function(a) + evaluate_function(b)
	
	for i in range(1, n):
		var x = a + i * h
		if i % 2 == 1:
			result += 4.0 * evaluate_function(x)
		else:
			result += 2.0 * evaluate_function(x)
	
	return result * h / 3.0

func evaluate_function(x: float) -> float:
	return exp(-x/2.0) * sin(3.0 * x) * cos(2.0 * x)

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible = false

func _on_check_button_pressed() -> void:
	show_detailed_calculation()

func test_accuracy_for_segments():
	print("Test dokładności dla różnych liczby segmentów:")
	for segments in range(6, 31, 2):
		var approx = simpson_method(segments)
		var error = abs(approx - exact_solution)
		var accuracy = 1.0 - (error / abs(exact_solution))
		print("Segmenty: %d, Dokładność: %.4f%%" % [segments, accuracy * 100])
