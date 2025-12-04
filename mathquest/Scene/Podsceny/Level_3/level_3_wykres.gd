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

@onready var exit: Button = $MarginContainer/Exit
@onready var output_display: TextEdit = $MarginContainer/Terminal/VBoxContainer/OutputDisplay
@onready var select_func: OptionButton = $MarginContainer/Terminal/VBoxContainer3/VBoxContainer/GridContainer/SelectFunc
@onready var x_0: LineEdit = $MarginContainer/Terminal/VBoxContainer3/VBoxContainer/GridContainer/X0
@onready var x_1: LineEdit = $MarginContainer/Terminal/VBoxContainer3/VBoxContainer/GridContainer/X1
@onready var tolerance: LineEdit = $MarginContainer/Terminal/VBoxContainer3/VBoxContainer/GridContainer/Tolerance
@onready var graph_display: FunctionPlotter = $MarginContainer/Terminal/VBoxContainer3/GraphDisplay
@onready var status_label: Label = $MarginContainer/Terminal/VBoxContainer/StatusLabel
@onready var pseudocode_container: VBoxContainer = $MarginContainer/Terminal/VBoxContainer2/PseudocodeContainer
@onready var drag_f_x_1___f_x_0_: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag(f_x1 - f_x0)"
@onready var drag_f_x_0___f_x_1_: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag(f_x0 + f_x1)"
@onready var drag_x_0___x_1_: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag(x0 = x1)"
@onready var drag_x_1___x_2_: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag(x1 = x2)"
@onready var drag_x_0___x_2_: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag(x0 = x2)"
@onready var drag_x_1___x_0_: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag(x1 = x0)"
@onready var drag_error_tolerance1: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag1(error > tolerance)"
@onready var drag_error_tolerance2: Button = $"MarginContainer/Terminal/VBoxContainer2/DragItems/Drag2(error < tolerance)"

var available_functions = {
	"f(x) = x² - 9": {"func": "x**2 - 9", "solution": 3.0, "hint": "Miejsce zerowe w x=3"},
	"f(x) = x³ - 8": {"func": "x**3 - 8", "solution": 2.0, "hint": "Miejsce zerowe w x=2"},
	"f(x) = sin(x - 1)": {"func": "sin(x - 1)", "solution": 1.0, "hint": "Miejsce zerowe w x=1"},
	"f(x) = cos(x) - 0.5": {"func": "cos(x) - 0.5", "solution": 1.047, "hint": "Miejsce zerowe w x≈1.047"},
	"f(x) = exp(x) - 5": {"func": "exp(x) - 5", "solution": 1.609, "hint": "Miejsce zerowe w x≈1.609"},
	"f(x) = ln(x)": {"func": "log(x)", "solution": 1.0, "hint": "Miejsce zerowe w x=1"},
	"f(x) = x² + x - 6": {"func": "x**2 + x - 6", "solution": 2.0, "hint": "Miejsce zerowe w x=2"},
	"f(x) = x³ + 2x² - 5x - 6": {"func": "x**3 + 2*x**2 - 5*x - 6", "solution": 2.0, "hint": "Miejsce zerowe w x=2"}
}

var current_function_key: String = "f(x) = x² - 9"
var solved_functions = {}
const MAX_ITERATIONS = 50

var drop_targets = {
	"denominator": {"correct": "f_x1 - f_x0", "filled": false, "node": null, "symbol": "?-/+?"},
	"condition": {"correct": "error > tolerance", "filled": false, "node": null, "symbol": "?>/<?"},
	"update_x0": {"correct": "x0 = x1", "filled": false, "node": null, "symbol": "?=?"},
	"update_x1": {"correct": "x1 = x2", "filled": false, "node": null, "symbol": "?=?"}
}

var dragged_item: Control = null
var dragged_item_text: String = ""
var dragged_item_original_position: Vector2

func _ready() -> void:
	initialize_default_values()
	setup_text_edits()
	create_pseudocode_with_drop_zones()
	populate_function_selection()
	setup_graph_display()
	setup_drag_buttons()

func setup_text_edits() -> void:
	output_display.size_flags_vertical = Control.SIZE_EXPAND_FILL
	output_display.custom_minimum_size.y = 800
	output_display.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	output_display.editable = false

func setup_drag_buttons() -> void:
	drag_f_x_1___f_x_0_.add_theme_color_override("background_color", Color.DARK_GREEN)
	drag_x_0___x_1_.add_theme_color_override("background_color", Color.DARK_GREEN)
	drag_x_1___x_2_.add_theme_color_override("background_color", Color.DARK_GREEN)
	drag_error_tolerance1.add_theme_color_override("background_color", Color.DARK_GREEN)
	
	drag_f_x_0___f_x_1_.add_theme_color_override("background_color", Color.DARK_RED)
	drag_x_0___x_2_.add_theme_color_override("background_color", Color.DARK_RED)
	drag_x_1___x_0_.add_theme_color_override("background_color", Color.DARK_RED)
	drag_error_tolerance2.add_theme_color_override("background_color", Color.DARK_RED)
	
	for button in [drag_f_x_1___f_x_0_, drag_f_x_0___f_x_1_, drag_x_0___x_1_, drag_x_1___x_2_,
				  drag_x_0___x_2_, drag_x_1___x_0_, drag_error_tolerance1, drag_error_tolerance2]:
		button.add_theme_color_override("font_color", Color.WHITE)

func create_pseudocode_with_drop_zones() -> void:
	for child in pseudocode_container.get_children():
		child.queue_free()
	
	create_code_part("""METODA SIECZNYCH (PSEUDOKOD)
1. INICJALIZACJA:
- x₀ = punkt początkowy 1  
- x₁ = punkt początkowy 2  
- tolerance = dokładność  
- max_iterations = maks. liczba iteracji""")
	create_code_part("""
2. PĘTLA ITERACYJNA:
DOPÓKI (iter < max_iterations) I""")
	create_drop_zone("condition", "Warunek kontynuacji pętli")
	create_code_part("""
a) OBLICZENIE WARTOŚCI FUNKCJI:  
   f_x0 = f(x₀)  
   f_x1 = f(x₁)
b) WZÓR METODY SIECZNYCH:  
   x₂ = x₁ - f_x1 * (x₁ - x₀) /""")
	create_drop_zone("denominator", "Mianownik wzoru")
	create_code_part("""
c) OBLICZENIE BŁĘDU:  
   error = |f(x₂)|
d) AKTUALIZACJA PUNKTÓW:""")
	create_drop_zone("update_x0")

	var sep := HSeparator.new()
	sep.custom_minimum_size = Vector2(0, 6)
	$MarginContainer/Terminal/VBoxContainer2/PseudocodeContainer.add_child(sep)

	create_drop_zone("update_x1")

	create_code_part("""
e) INKREMENTACJA:  
   iter = iter + 1
3. WYNIK:
- Jeżeli error ≤ tolerance: ZBIEŻNOŚĆ  
- W przeciwnym razie: BRAK ZBIEŻNOŚCI
PRZECIĄGNIJ ELEMENTY DO ODPOWIEDNICH STREF W PSEUDOKODZIE""")

func create_code_part(text: String) -> void:
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_size", 25)
	pseudocode_container.add_child(label)

func create_drop_zone(zone_name: String, hint: String = "") -> void:
	var zone_container = PanelContainer.new()
	zone_container.name = "DropZone_" + zone_name
	zone_container.custom_minimum_size = Vector2(200, 55)
	
	var hbox = HBoxContainer.new()
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var label = Label.new()
	label.text = "[ PRZECIĄGNIJ " + drop_targets[zone_name]["symbol"] + " ]"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	zone_container.add_theme_stylebox_override("panel", create_zone_stylebox())
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_size", 12)
	
	hbox.add_child(label)
	zone_container.add_child(hbox)
	pseudocode_container.add_child(zone_container)
	
	drop_targets[zone_name]["node"] = zone_container
	
	if hint != "":
		var hint_label = Label.new()
		hint_label.text = "   // " + hint
		hint_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
		hint_label.add_theme_color_override("font_size", 10)
		pseudocode_container.add_child(hint_label)

func create_zone_stylebox() -> StyleBoxFlat:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.2, 0.2, 0.8, 0.8)
	stylebox.border_color = Color(0.1, 0.1, 0.5, 1.0)
	stylebox.border_width_left = 2
	stylebox.border_width_top = 2
	stylebox.border_width_right = 2
	stylebox.border_width_bottom = 2
	stylebox.corner_radius_top_left = 5
	stylebox.corner_radius_top_right = 5
	stylebox.corner_radius_bottom_right = 5
	stylebox.corner_radius_bottom_left = 5
	stylebox.content_margin_left = 10
	stylebox.content_margin_top = 8
	stylebox.content_margin_right = 10
	stylebox.content_margin_bottom = 8
	return stylebox

func _on_dragf_x_1__f_x_0_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_f_x_1___f_x_0_, "f_x1 - f_x0")

func _on_dragf_x_0__f_x_1_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_f_x_0___f_x_1_, "f_x0 + f_x1")

func _on_dragx_0__x_1_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_x_0___x_1_, "x0 = x1")

func _on_dragx_1__x_2_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_x_1___x_2_, "x1 = x2")

func _on_dragx_0__x_2_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_x_0___x_2_, "x0 = x2")

func _on_dragx_1__x_0_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_x_1___x_0_, "x1 = x0")

func _on_dragerror__tolerance_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_error_tolerance1, "error > tolerance")
	
func _on_drag_2_error__tolerance_gui_input(event: InputEvent) -> void:
	_handle_drag_input(event, drag_error_tolerance2, "error < tolerance")


func _handle_drag_input(event: InputEvent, button: Button, element_text: String) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragged_item_original_position = button.global_position
			
			var drag_copy = Button.new()
			drag_copy.text = button.text
			drag_copy.size = button.size
			drag_copy.add_theme_color_override("font_color", button.get_theme_color("font_color"))
			drag_copy.add_theme_color_override("background_color", button.get_theme_color("background_color"))
			add_child(drag_copy)
			drag_copy.global_position = get_global_mouse_position() - drag_copy.size / 2
			
			dragged_item = drag_copy
			dragged_item_text = element_text
		else:
			if dragged_item:
				check_drop_position()
				dragged_item.queue_free()
				dragged_item = null
			reset_drop_zone_highlights()
	
	if event is InputEventMouseMotion and dragged_item:
		dragged_item.global_position = get_global_mouse_position() - dragged_item.size / 2
		
		for zone_name in drop_targets:
			var zone_node = drop_targets[zone_name]["node"]
			if zone_node:
				var zone_rect = Rect2(zone_node.global_position, zone_node.size)
				if zone_rect.has_point(dragged_item.global_position + dragged_item.size / 2):
					var stylebox = zone_node.get_theme_stylebox("panel").duplicate()
					stylebox.bg_color = Color(0.8, 0.8, 0.2, 0.8)
					zone_node.add_theme_stylebox_override("panel", stylebox)
				else:
					var stylebox = create_zone_stylebox()
					zone_node.add_theme_stylebox_override("panel", stylebox)

func reset_drop_zone_highlights() -> void:
	for zone_name in drop_targets:
		var zone_node = drop_targets[zone_name]["node"]
		if zone_node:
			zone_node.add_theme_stylebox_override("panel", create_zone_stylebox())

func highlight_drop_zones(highlight: bool) -> void:
	for zone_name in drop_targets:
		var zone_node = drop_targets[zone_name]["node"]
		if zone_node:
			var stylebox = zone_node.get_theme_stylebox("panel").duplicate()
			if highlight:
				stylebox.bg_color = Color(0.8, 0.8, 0.2, 0.8)
			else:
				stylebox.bg_color = Color(0.2, 0.2, 0.8, 0.8)
			zone_node.add_theme_stylebox_override("panel", stylebox)

func check_drop_position() -> void:
	if not dragged_item:
		return
	
	var item_dropped = false
	
	for zone_name in drop_targets:
		var zone_node = drop_targets[zone_name]["node"]
		if zone_node:
			var zone_rect = zone_node.get_global_rect()
			var item_rect = dragged_item.get_global_rect()
			
			if zone_rect.intersects(item_rect, true):
				if dragged_item_text == drop_targets[zone_name]["correct"]:
					drop_targets[zone_name]["filled"] = true
					
					var label = zone_node.get_child(0).get_child(0) as Label
					label.text = "✓ " + dragged_item_text
					label.add_theme_color_override("font_color", Color.GREEN)
					
					var stylebox = create_success_stylebox()
					zone_node.add_theme_stylebox_override("panel", stylebox)
					
					output_display.text += "✓ Poprawnie umieszczono element\n"
					item_dropped = true
					
					match dragged_item_text:
						"f_x1 - f_x0": drag_f_x_1___f_x_0_.visible = false
						"x0 = x1": drag_x_0___x_1_.visible = false
						"x1 = x2": drag_x_1___x_2_.visible = false
						"error > tolerance": drag_error_tolerance1.visible = false
						"f_x0 + f_x1": drag_f_x_0___f_x_1_.visible = false
						"x0 = x2": drag_x_0___x_2_.visible = false
						"x1 = x0": drag_x_1___x_0_.visible = false
						"error < tolerance": drag_error_tolerance2.visible = false
				else:
					output_display.text += "❌ Błędny element w tym miejscu!\n"
					item_dropped = true
				break
	
	if not item_dropped:
		output_display.text += "Element upuszczony poza strefą docelową\n"


func create_success_stylebox() -> StyleBoxFlat:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.2, 0.8, 0.2, 0.8)
	stylebox.border_color = Color(0.1, 0.5, 0.1, 1.0)
	stylebox.border_width_left = 2
	stylebox.border_width_top = 2
	stylebox.border_width_right = 2
	stylebox.border_width_bottom = 2
	stylebox.corner_radius_top_left = 5
	stylebox.corner_radius_top_right = 5
	stylebox.corner_radius_bottom_right = 5
	stylebox.corner_radius_bottom_left = 5
	return stylebox

func parse_function(func_string: String):
	var expression = Expression.new()
	if expression.parse(func_string, ["x"]) != OK:
		return null
	
	return func(x: float) -> float:
		var result = expression.execute([x])
		return NAN if expression.has_execute_failed() else result

func setup_graph_display() -> void:
	if graph_display and graph_display.has_method("set_function"):
		var first_func_data = available_functions["f(x) = x² - 9"]
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
	x_0.text = "2.0"
	x_1.text = "4.0"
	tolerance.text = "0.0001"

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	get_tree().paused = false
	visible = false

func _on_calculation_pressed() -> void:
	output_display.text = ""
	if validate_inputs() and validate_drag_elements():
		calculate_secant_method()

func _on_reset_pressed() -> void:
	initialize_default_values()
	output_display.text = ""
	status_label.text = "System gotowy. Wybierz funkcję i rozpocznij obliczenia."
	reset_drag_elements()
	if graph_display and graph_display.has_method("clear_roots"):
		graph_display.clear_roots()

func reset_drag_elements() -> void:
	for zone_name in drop_targets:
		drop_targets[zone_name]["filled"] = false
		
		var zone_node = drop_targets[zone_name]["node"]
		if zone_node:
			var label = zone_node.get_child(0).get_child(0) as Label
			label.text = "[ PRZECIĄGNIJ " + drop_targets[zone_name]["symbol"] + " ]"
			label.add_theme_color_override("font_color", Color.WHITE)
			zone_node.add_theme_stylebox_override("panel", create_zone_stylebox())
	
	drag_f_x_1___f_x_0_.visible = true
	drag_f_x_0___f_x_1_.visible = true
	drag_x_0___x_1_.visible = true
	drag_x_1___x_2_.visible = true
	drag_x_0___x_2_.visible = true
	drag_x_1___x_0_.visible = true
	drag_error_tolerance1.visible = true
	drag_error_tolerance2.visible = true

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
	
	return true

func validate_drag_elements() -> bool:
	for zone_name in drop_targets:
		if not drop_targets[zone_name]["filled"]:
			show_error("Umieść wszystkie elementy w algorytmie!")
			return false
	
	output_display.text += "✓ Algorytm poprawnie skonfigurowany!\n"
	return true

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
