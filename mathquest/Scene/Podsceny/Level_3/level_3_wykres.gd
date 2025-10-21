extends Control

class SecantResult:
	var root: float
	var iterations: int
	var converged: bool
	var error: float
	var function_value: float
	
	func _init(r: float, i: int, c: bool, e: float, fv: float):
		root = r
		iterations = i
		converged = c
		error = e
		function_value = fv

signal function_solved(function_name: String)

@onready var exit: Button = $Exit
@onready var code_display: TextEdit = $Terminal/VBoxContainer2/CodeDisplay
@onready var output_display: TextEdit = $Terminal/VBoxContainer/OutputDisplay
@onready var select_func: OptionButton = $Terminal/VBoxContainer3/VBoxContainer/GridContainer/SelectFunc
@onready var x_0: LineEdit = $Terminal/VBoxContainer3/VBoxContainer/GridContainer/X0
@onready var x_1: LineEdit = $Terminal/VBoxContainer3/VBoxContainer/GridContainer/X1
@onready var tolerance: LineEdit = $Terminal/VBoxContainer3/VBoxContainer/GridContainer/Tolerance
@onready var graph_display: Control = $Terminal/VBoxContainer2/GraphDisplay
@onready var status_label: Label = $Terminal/VBoxContainer/StatusLabel

var available_functions = {
	"f(x) = x² - 4": {"func": "x**2 - 4", "solution": 2.0, "hint": "Prosta funkcja kwadratowa"},
	"f(x) = x³ - 2x - 5": {"func": "x**3 - 2*x - 5", "solution": 2.094, "hint": "Wielomian 3 stopnia"},
	"f(x) = sin(x)": {"func": "sin(x)", "solution": 0.0, "hint": "Funkcja trygonometryczna"},
	"f(x) = cos(x) - x": {"func": "cos(x) - x", "solution": 0.739, "hint": "Mieszana trygonometryczna"},
	"f(x) = exp(-x) - x": {"func": "exp(-x) - x", "solution": 0.567, "hint": "Funkcja wykładnicza"},
	"f(x) = ln(x + 1)": {"func": "log(x + 1)", "solution": 0.0, "hint": "Logarytm naturalny"},
	"f(x) = x² + sin(x) - 1": {"func": "x**2 + sin(x) - 1", "solution": 0.637, "hint": "Mieszana kwadratowo-trygonometryczna"}
}

var current_function_key: String = "f(x) = x² - 4"
var solved_functions = {}
const MAX_ITERATIONS = 50  

func _ready() -> void:
	initialize_default_values()
	setup_text_edits()
	update_code_display()
	populate_function_selection()
	setup_graph_display()

func setup_text_edits() -> void:
	code_display.size_flags_vertical = Control.SIZE_EXPAND_FILL
	code_display.custom_minimum_size.y = 200
	output_display.size_flags_vertical = Control.SIZE_EXPAND_FILL
	output_display.custom_minimum_size.y = 900
	
	code_display.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	output_display.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	code_display.editable = false
	output_display.editable = false

func setup_graph_display() -> void:
	if graph_display and graph_display.has_method("set_function"):
		var first_func_data = available_functions["f(x) = x² - 4"]
		var parsed_function = parse_function(first_func_data["func"])
		if parsed_function != null:
			graph_display.set_function(parsed_function)

func populate_function_selection() -> void:
	for func_key in available_functions.keys():
		select_func.add_item(func_key)
	select_func.select(0)
	_on_select_func_item_selected(0)

func _on_select_func_item_selected(index: int) -> void:
	current_function_key = select_func.get_item_text(index)
	var func_data = available_functions[current_function_key]
	status_label.text = "Wybrano: " + current_function_key + " - " + func_data["hint"]

func initialize_default_values() -> void:
	x_0.text = ""
	x_1.text = ""
	tolerance.text = "0.0001"
	# MAX_ITERATIONS jest stałą - nie ma pola do wypełnienia

func update_code_display() -> void:
	var code = """// ALGORYTM METODY SIECZNYCH
func secant_method(f: Callable, x0: float, x1: float, 
                  tolerance: float, max_iterations: int):
    
    var iteration = 0
    var error = abs(f(x1))
    
    while iteration < max_iterations and error > tolerance:
        var f_x0 = f(x0)
        var f_x1 = f(x1)
        
        if abs(f_x1 - f_x0) < 1e-12:
            break
            
        var x2 = x1 - f_x1 * (x1 - x0) / (f_x1 - f_x0)
        x0 = x1
        x1 = x2
        error = abs(f(x1))
        iteration += 1
    
    return {
        "root": x1,
        "iterations": iteration,
        "converged": error <= tolerance,
        "error": error
    }"""
	code_display.text = code

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	get_tree().paused = false
	visible = false

func _on_calculation_pressed() -> void:
	output_display.text = ""
	if validate_inputs():
		calculate_secant_method()

func _on_reset_pressed() -> void:
	initialize_default_values()
	output_display.text = ""
	status_label.text = "System gotowy. Wybierz funkcję i rozpocznij obliczenia."
	if graph_display and graph_display.has_method("clear_roots"):
		graph_display.clear_roots()

func validate_inputs() -> bool:
	if x_0.text.strip_edges().is_empty() or x_1.text.strip_edges().is_empty():
		show_error("Wartości x₀ i x₁ są wymagane!")
		return false
	
	var x0 = x_0.text.to_float()
	var x1 = x_1.text.to_float()
	
	if x0 == x1:
		show_error("x₀ i x₁ nie mogą być równe!")
		return false
	
	if tolerance.text.to_float() <= 0:
		show_error("Tolerancja musi być większa od zera!")
		return false
	
	return true  # Nie sprawdzamy już max_iterations

func show_error(message: String) -> void:
	status_label.text = "BŁĄD: " + message
	output_display.text += "\n❌ " + message + "\n"

func calculate_secant_method() -> void:
	var func_data = available_functions[current_function_key]
	var function_expression = func_data["func"]
	var x0 = x_0.text.to_float()
	var x1 = x_1.text.to_float()
	var tolerance_val = tolerance.text.to_float()
	
	var parsed_function = parse_function(function_expression)
	if parsed_function == null:
		show_error("Błąd parsowania funkcji: " + function_expression)
		return
	
	if graph_display and graph_display.has_method("set_function"):
		graph_display.set_function(parsed_function)
	
	var result = secant_method(parsed_function, x0, x1, tolerance_val, MAX_ITERATIONS)
	display_results(result, func_data)
	
	if result.converged and graph_display and graph_display.has_method("add_root"):
		graph_display.add_root(result.root)
	
	check_progress(result, func_data)

func parse_function(func_string: String):
	var expression = Expression.new()
	if expression.parse(func_string, ["x"]) != OK:
		return null
	
	return func(x: float) -> float:
		var result = expression.execute([x])
		return NAN if expression.has_execute_failed() else result

func secant_method(func_callable: Callable, x0: float, x1: float, 
				  tolerance_val: float, max_iterations_val: int) -> SecantResult:
	
	var iteration = 0
	var error = abs(func_callable.call(x1))
	var current_x = x1
	
	output_display.text += "\n=== ROZPOCZĘCIE METODY SIECZNYCH ===\n"
	output_display.text += "Funkcja: " + current_function_key + "\n"
	output_display.text += "Przedział: [" + str(x0) + ", " + str(x1) + "]\n"
	output_display.text += "Tolerancja: " + str(tolerance_val) + "\n"
	output_display.text += "Maks. iteracji: " + str(MAX_ITERATIONS) + "\n\n"
	output_display.text += "Iter\tx\t\tf(x)\t\tBłąd\n"
	
	if graph_display and graph_display.has_method("clear_secants"):
		graph_display.clear_secants()
	
	while iteration < max_iterations_val and error > tolerance_val:
		var f0 = func_callable.call(x0)
		var f1 = func_callable.call(x1)
		
		if graph_display and graph_display.has_method("add_secant_points"):
			graph_display.add_secant_points(x0, x1)
		
		if abs(f1 - f0) < 1e-12:
			output_display.text += "⚠ Zatrzymano: zbyt mały mianownik\n"
			break
		
		var x2 = x1 - f1 * (x1 - x0) / (f1 - f0)
		x0 = x1
		x1 = x2
		error = abs(func_callable.call(x1))
		iteration += 1
		
		output_display.text += "%d\t%.6f\t%.6f\t%.6f\n" % [iteration, x1, func_callable.call(x1), error]
	
	return SecantResult.new(x1, iteration, error <= tolerance_val, error, func_callable.call(x1))

func display_results(result: SecantResult, func_data: Dictionary) -> void:
	var status_text = "ZBIEŻNOŚĆ OSIĄGNIĘTA" if result.converged else "BRAK ZBIEŻNOŚCI"
	
	output_display.text += "\n=== WYNIK ===\n"
	output_display.text += "Status: " + status_text + "\n"
	output_display.text += "Przybliżone miejsce zerowe: x ≈ " + str(result.root) + "\n"
	output_display.text += "Wartość funkcji: f(x) = " + str(result.function_value) + "\n"
	output_display.text += "Liczba iteracji: " + str(result.iterations) + "\n"
	output_display.text += "Ostateczny błąd: " + str(result.error) + "\n"
	
	output_display.scroll_vertical = output_display.get_line_count()

func check_progress(result: SecantResult, func_data: Dictionary) -> void:
	var expected_solution = func_data["solution"]
	var difference = abs(result.root - expected_solution)
	
	if result.converged and difference < 0.01:
		if not solved_functions.has(current_function_key):
			solved_functions[current_function_key] = true
			output_display.text += "🎉 FUNKCJA POPRAWNIE ROZWIĄZANA!\n"
			status_label.text = "✓ " + current_function_key + " - ROZWIĄZANA"
			function_solved.emit(current_function_key)
			
			var solved_count = solved_functions.size()
			output_display.text += "Rozwiązano " + str(solved_count) + "/2 różnych funkcji\n"
		else:
			output_display.text += "✓ Ta funkcja została już rozwiązana!\n"
			output_display.text += "Spróbuj rozwiązać inną funkcję z listy.\n"
	else:
		output_display.text += "ℹ Oczekiwane rozwiązanie: x ≈ " + str(expected_solution) + "\n"

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode in [KEY_ENTER, KEY_KP_ENTER] and get_viewport().gui_get_focus_owner() is LineEdit:
			_on_calculation_pressed()
