extends Control

class_name RectangleMethodComputer

var current_function: String = "sin(4*x)*exp(x/2)"
var integration_limits: Array = [0.0, 3.0]
var num_rectangles: int = 8
var exact_solution: float = 0.0
var target_accuracy: float = 0.98
var optimal_range: Array = [12, 18]

@onready var task_label: Label = $TaskLabel
@onready var function_graph: ColorRect = $"Function Graph"
@onready var result_label: Label = $Panel/ResultLabel
@onready var rect_count_value: Label = $Panel/Vbox/RectCountValue
@onready var rect_count_slider: HSlider = $Panel/Vbox/RectCountSlider
@onready var check_button: Button = $Panel/Vbox/CheckButton
@onready var calculation_label: Label = $Panel/CalculationLabel

func _ready() -> void:
	setup_ui()
	exact_solution = calculate_exact_solution()
	update_display()

func setup_ui():
	result_label.visible = false
	rect_count_slider.value_changed.connect(_on_rect_count_slider_value_changed)
	
	rect_count_slider.min_value = 4
	rect_count_slider.max_value = 25
	rect_count_slider.value = 8
	rect_count_slider.step = 1
		
	update_rect_count_display()

	

func update_display():
	visualize_rectangles()
	result_label.visible = false
	show_calculation_steps()

func visualize_rectangles():
	if function_graph:
		function_graph.set_problem(current_function, integration_limits)
		function_graph.update_visualization("rectangles", num_rectangles)

func update_rect_count_display():
	rect_count_value.text = "Prostokąty: %d" % num_rectangles
	visualize_rectangles()
	show_calculation_steps()

func show_calculation_steps():
	var calculation_text = "Obliczenia dla %d prostokątów:\n\n" % num_rectangles
	
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = num_rectangles
	var h = (b - a) / n
	
	calculation_text += "h = (3 - 0) / %d = %.3f\n\n" % [n, h]
	
	var total_sum = 0.0
	for i in range(min(n, 4)):
		var x_mid = a + (i + 0.5) * h
		var y_mid = evaluate_function(x_mid)
		total_sum += y_mid
		calculation_text += "x%d = %.3f → f(x) = %.3f\n" % [i+1, x_mid, y_mid]
	
	if n > 4:
		calculation_text += "...\n"
		for i in range(4, n):
			var x_mid = a + (i + 0.5) * h
			total_sum += evaluate_function(x_mid)
	
	var result = total_sum * h
	calculation_text += "\nWynik = %.3f" % result
	
	calculation_label.text = calculation_text

func show_detailed_calculation():
	var approx_result = rectangle_method(num_rectangles)
	var error = abs(approx_result - exact_solution)
	
	var accuracy = 0.0
	if exact_solution != 0:
		accuracy = 1.0 - min(error / abs(exact_solution), 1.0)
	else:
		accuracy = 1.0 - min(error, 1.0) 
	
	var percentage = accuracy * 100
	
	var result_text = "Wynik dla %d prostokątów:\n\n" % num_rectangles
	
	result_text += "Przybliżony: %.3f\n" % approx_result
	result_text += "Dokładny:    %.3f\n" % exact_solution
	result_text += "Dokładność:  %.1f%%\n\n" % percentage
	
	var is_optimal_range = (num_rectangles >= optimal_range[0] and num_rectangles <= optimal_range[1])
	var is_high_accuracy = (accuracy >= target_accuracy)
	
	if is_optimal_range and is_high_accuracy:
		result_text += "Dobrze"
		result_label.modulate = Color.GREEN
	elif num_rectangles < optimal_range[0]:
		result_text += "Za mało"
		result_label.modulate = Color.RED
	else:
		result_text += "Za dużo"
		result_label.modulate = Color.ORANGE
	
	result_label.text = result_text
	result_label.visible = true

func calculate_exact_solution() -> float:
	return approximate_exact_solution()

func approximate_exact_solution() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = 2000
	var h = (b - a) / n
	var result = evaluate_function(a) + evaluate_function(b)
	
	for i in range(1, n):
		var x = a + i * h
		var coefficient = 4.0 if i % 2 == 1 else 2.0
		result += coefficient * evaluate_function(x)
	
	return result * h / 3.0

func rectangle_method(n: int) -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var h = (b - a) / n
	var result = 0.0
	
	for i in range(n):
		var x = a + (i + 0.5) * h
		result += evaluate_function(x)
	
	return result * h

func evaluate_function(x: float) -> float:
	return sin(4.0 * x) * exp(x/2.0)

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible = false

func _on_rect_count_slider_value_changed(value: float) -> void:
	num_rectangles = int(value)
	update_rect_count_display()


func _on_check_button_pressed() -> void:
	show_detailed_calculation()
