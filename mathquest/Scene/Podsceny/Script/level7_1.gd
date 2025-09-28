extends Control

@onready var input_a: LineEdit = $Container/VBoxContainer2/HBoxA/InputA
@onready var input_b: LineEdit = $Container/VBoxContainer2/HBoxB/InputB
@onready var graph: Panel = $Graph
@onready var output: Label = $Container/Wynik
@onready var results_label: RichTextLabel = $PanelContainer/RichTextLabel

var a: float
var b: float
var x: float
var has_point := false

func f(v: float) -> float:
	return pow(v,3) - 6*pow(v,2) + 8*v - 3

func _on_oblicz_pressed() -> void:
	a = input_a.text.to_float()
	b = input_b.text.to_float()


	if f(a) * f(b) > 0:
		output.text = "❌ Zły przedział (f(a)*f(b) > 0)"
		return

	# pokaz iteracje w tabelce
	results_label.text = calculate_iterations(a, b)

	# obliczamy pierwszy punkt do wykresu i logiki przedziałów
	x = (a*f(b) - b*f(a)) / (f(b)-f(a))
	output.text = "Pierwszy punkt x = %.4f" % x
	has_point = true

	# aktualizacja wykresu
	graph.a = a
	graph.b = b
	graph.x = x
	graph.f = Callable(self, "f")
	graph.queue_redraw()

func _on_przedzial_a_pressed() -> void:
	if not has_point:
		output.text = "Najpierw oblicz punkt!"
		return

	if f(a) * f(x) < 0:
		b = x
		output.text += "\n✅ Dobry wybór przedziału [a, x]"
		input_b.text = str(b)  # <-- automatycznie wpisujemy nową wartość do LineEdit
		if abs(f(x)) < 0.01:
			output.text += "\n🎉 Znalazłeś rozwiązanie!"
	else:
		output.text += "\n❌ Zły wybór"

	# aktualizacja RichTextLabel i wykresu
	results_label.text = calculate_iterations(a, b)
	graph.a = a
	graph.b = b
	graph.x = x
	graph.queue_redraw()


func _on_przedzial_b_pressed() -> void:
	if not has_point:
		output.text = "Najpierw oblicz punkt!"
		return

	if f(x) * f(b) < 0:
		a = x
		output.text += "\n✅ Dobry wybór przedziału [x, b]"
		input_a.text = str(a)
		if abs(f(x)) < 0.01:
			output.text += "\n🎉 Znalazłeś rozwiązanie!"
	else:
		output.text += "\n❌ Zły wybór"

	# aktualizacja RichTextLabel i wykresu
	results_label.text = calculate_iterations(a, b)
	graph.a = a
	graph.b = b
	graph.x = x
	graph.queue_redraw()


func calculate_iterations(a: float, b: float, tol := 0.001, max_iter := 20) -> String:
	var fa = f(a)
	var fb = f(b)
	var output := "Iteracje Reguły Falsi:\n"
	output += " i    a       b       x       f(x)\n"  # nagłówek z odstępami

	for i in range(1, max_iter+1):
		var x_val = (a*fb - b*fa)/(fb - fa)
		var fx = f(x_val)
		output += "%2d  %7.4f  %7.4f  %7.4f  %7.4f\n" % [i, a, b, x_val, fx]
		
		if abs(fx) < tol:
			break
		if fa*fx < 0:
			b = x_val
			fb = fx
		else:
			a = x_val
			fa = fx
	return output

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible= false
