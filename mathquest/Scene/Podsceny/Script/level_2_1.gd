extends Control

@onready var input_a: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainerA/InputA
@onready var input_b: LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/GridContainer/HBoxContainerB/InputB
@onready var output: Label = $MarginContainer/VBoxContainer/HBoxContainer3/Wynik
@onready var results_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer4/RichTextLabel
@onready var graph: Panel = $MarginContainer/VBoxContainer/PanelContainer/Graph

var a: float
var b: float
var x: float
var has_point := false

# 🔹 Funkcja z jednym miejscem zerowym (~1.521)
func f(v: float) -> float:
	return pow(v, 3) - v - 2


func _on_oblicz_pressed() -> void:
	a = input_a.text.to_float()
	b = input_b.text.to_float()

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

	var fa = f(a)
	var fb = f(b)
	var fx = f(x)

	# Wybór strony przedziału i aktualizacja dynamiczna
	if use_left:
		# wybór przedziału [a, x]
		if fa * fx < 0:
			b = x
			output.text = "✅ Dobry wybór: przedział [a, x]"
		else:
			output.text = "❌ Zły wybór: przedział [a, x]"
	else:
		# wybór przedziału [x, b]
		if fx * fb < 0:
			a = x
			output.text = "✅ Dobry wybór: przedział [x, b]"
		else:
			output.text = "❌ Zły wybór: przedział [x, b]"

	# 🔁 zawsze licz nowy punkt po aktualizacji
	x = (a * f(b) - b * f(a)) / (f(b) - f(a))
	input_a.text = "%.4f" % a
	input_b.text = "%.4f" % b

	# Warunek zakończenia (blisko zera)
	if abs(f(x)) < 0.001:
		output.text += "\n🎉 Znalazłeś rozwiązanie: x = %.4f" % x

	results_label.text = calculate_iterations(a, b)
	update_graph()


func calculate_iterations(a: float, b: float, tol := 0.001, max_iter := 20) -> String:
	var fa = f(a)
	var fb = f(b)
	var output := "Iteracje Reguły Falsi:\n"
	output += "[i]      a         b         x        f(x)\n"

	for i in range(1, max_iter + 1):
		var x_val = (a * fb - b * fa) / (fb - fa)
		var fx = f(x_val)
		output += "%2d   %8.4f  %8.4f  %8.4f  %8.4f\n" % [i, a, b, x_val, fx]

		if abs(fx) < tol:
			output += "\n✅ Zbieżność osiągnięta po %d iteracjach." % i
			break

		if fa * fx < 0:
			b = x_val
			fb = fx
		else:
			a = x_val
			fa = fx

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
	if Engine.has_singleton("Global"):
		Global.can_move = true
