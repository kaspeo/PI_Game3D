extends Control

@onready var method_lab: Label = $CanvasLayer/Control/Results/VBoxContainer/MethodLab
@onready var con_lab: Label = $CanvasLayer/Control/Results/VBoxContainer/ConLab
@onready var root_lab: Label = $CanvasLayer/Control/Results/VBoxContainer/RootLab
@onready var iter_lab: Label = $CanvasLayer/Control/Results/VBoxContainer/IterLab
@onready var error_labe: Label = $CanvasLayer/Control/Results/VBoxContainer/ErrorLabe
@onready var calc_text: Label = $CanvasLayer/Control/Results/VBoxContainer/CalcText

signal level_4_1_completed

@onready var graph_drawer: GraphDrawer = $Control

var current_result: Dictionary

const MAX_ITERATIONS = 50
const TOLERANCE = 1e-6

func _ready() -> void:
	if calc_text:
		calc_text.text = "Wybierz metodę, aby zobaczyć obliczenia..."

func _on_button_a_pressed() -> void:
	solve_and_display("a")

func _on_button_b_pressed() -> void:
	solve_and_display("b")

func _on_button_c_pressed() -> void:
	solve_and_display("c")

func _on_button_d_pressed() -> void:
	solve_and_display("d")

func _on_button_e_pressed() -> void:
	solve_and_display("e")

func solve_and_display(method_name: String):
	current_result = solve(method_name, 1.5)
	update_results_display()
	show_calculations(method_name)
	graph_drawer.setup_graph(current_result.iterations, method_name, current_result.converges)

func show_calculations(method: String):
	if not calc_text:
		return
	
	var calculations = {
		"a": """METODA A: x = x³ - 4.5

φ'(x) = 3x²
φ'(1) = 3, φ'(2) = 12

|φ'(x)| ≥ 3 > 1
❌ ROZBIEŻNA""",
		
		"b": """METODA B: x = 4.5/(x² + 1)

φ'(x) = -9x/(x²+1)²
|φ'(1)| = 2.25

max |φ'(x)| = 2.25 > 1
❌ ROZBIEŻNA""",
		
		"c": """METODA C: x = (x + 4.5)/x²

φ'(x) = -1/x² - 9/x³
|φ'(1)| = 10

max |φ'(x)| = 10 > 1
❌ ROZBIEŻNA""",
		
		"d": """METODA D: x = √((x + 4.5)/x)

φ(1) = √5.5 ≈ 2.345
φ(2) = √3.25 ≈ 1.803

φ([1,2]) = [1.803, 2.345] ⊄ [1,2]
❌ ROZBIEŻNA""",
		
		"e": """METODA E: x = ³√(x + 4.5)

φ(1) = ³√5.5 ≈ 1.765
φ(2) = ³√6.5 ≈ 1.867
|φ'(x)| ≈ 0.19 < 1

φ([1,2]) ⊂ [1,2]
|φ'(x)| < 1
✅ ZBIEŻNA"""
	}
	
	if method in calculations:
		calc_text.text = calculations[method]

func solve(method_name: String, initial_guess: float) -> Dictionary:
	var iterations = []
	var x = initial_guess
	var converges = false
	var root = 0.0
	var final_iteration = 0
	
	for i in range(MAX_ITERATIONS):
		var x_new = apply_method(method_name, x)
		
		if is_nan(x_new) or is_inf(x_new):
			break
		
		iterations.append({
			"iteration": i,
			"x_old": x,
			"x_new": x_new,
			"error": abs(x_new - x)
		})
		
		if abs(x_new - x) < TOLERANCE:
			converges = true
			root = x_new
			final_iteration = i
			break
		
		if abs(x_new) > 1000:
			break
			
		x = x_new
		final_iteration = i
	
	return {
		"method": method_name,
		"converges": converges,
		"root": root,
		"iterations": iterations,
		"final_iteration": final_iteration
	}

func apply_method(method: String, x: float) -> float:
	match method:
		"a":
			return x**3 - 4.5
		"b":
			return 4.5 / (x*x + 1.0)
		"c":
			return (x + 4.5) / (x*x)
		"d":
			if x <= 0:
				return NAN
			var value = (x + 4.5) / x
			if value < 0:
				return NAN
			return sqrt(value)
		"e":
			return pow(x + 4.5, 1.0/3.0)
		_:
			return x

func update_results_display():
	if current_result.is_empty():
		return
	
	method_lab.text = "Metoda: " + current_result.method.to_upper()
	
	if current_result.method == "e":
		con_lab.text = "Status: ZBIEŻNA ✅"
		con_lab.modulate = Color.GREEN
		root_lab.text = "Pierwiastek: " + str(current_result.root)
		iter_lab.text = "Liczba iteracji: " + str(current_result.final_iteration)
		var final_error = current_result.iterations[-1].error
		error_labe.text = "Błąd końcowy: " + str(final_error)
		level_4_1_completed.emit("metoda_iteracji")
	else:
		con_lab.text = "Status: ROZBIEŻNA ❌"
		con_lab.modulate = Color.RED
		root_lab.text = "Pierwiastek: BRAK"
		iter_lab.text = "Iteracje: " + str(current_result.final_iteration)
		error_labe.text = "Błąd: N/A"

func _on_clear_button_pressed() -> void:
	clear_display()

func clear_display():
	method_lab.text = "Metoda: ---"
	con_lab.text = "Status: ---"
	root_lab.text = "Pierwiastek: ---"
	iter_lab.text = "Liczba iteracji: ---"
	error_labe.text = "Błąd końcowy: ---"
	con_lab.modulate = Color.WHITE
	if calc_text:
		calc_text.text = "Wybierz metodę, aby zobaczyć obliczenia..."
	graph_drawer.clear_graph()


func _on_exit_pressed() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
