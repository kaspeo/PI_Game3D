extends Control

@onready var title: Label = $VBoxContainer/Title
@onready var graph: ColorRect = $VBoxContainer/Graph
@onready var wzor: Label = $VBoxContainer/Wzor

const STALY_WZOR = "W₃(x) = 1 + 2x + 0·x(x-1) + 1·x(x-1)(x-2)"

var solutions_data = {
	"empty": {
		"title": "EKRAŃ 2 INTERPOLACJA HERMITE'A",
		"key_points": PackedVector2Array(),
		"line_points": PackedVector2Array()
	},
	"correct": {
		"title": "EKRAŃ 2 POPRAWNE ROZWIĄZANIE",
		"key_points": PackedVector2Array([
			Vector2(0, 1),
			Vector2(1, 3), 
			Vector2(2, 7)
		]),
		"line_points": PackedVector2Array(),
		"color": Color.GREEN
	},
	"incorrect": {
		"title": "EKRAŃ 2 BŁĘDNE DANE",
		"key_points": PackedVector2Array([
			Vector2(-1, 2),
			Vector2(0, 0),
			Vector2(1, 1)
		]),
		"line_points": PackedVector2Array(),
		"color": Color.RED
	},
	"too_many": {
		"title": "ZA DUŻO PUDEŁEK!",
		"key_points": PackedVector2Array(),
		"line_points": PackedVector2Array(),
		"color": Color.ORANGE
	}
}

func _ready():
	solutions_data["correct"]["line_points"] = generate_line_points_ekran2()
	solutions_data["incorrect"]["line_points"] = generate_random_points()
	
	show_empty()
func show_empty():
	var data = solutions_data["empty"]
	title.text = data["title"]
	wzor.text = STALY_WZOR
	
	if graph.has_method("clear_solution"):
		graph.clear_solution()
	graph.visible = false

func show_correct_solution():
	var data = solutions_data["correct"]
	title.text = data["title"]
	wzor.text = STALY_WZOR
	
	if graph.has_method("draw_solution"):
		graph.draw_solution(data["key_points"], data["line_points"], data["color"])
	graph.visible = true

func show_incorrect_solution():
	var data = solutions_data["incorrect"]
	title.text = data["title"]
	wzor.text = STALY_WZOR
	
	if graph.has_method("draw_solution"):
		graph.draw_solution(data["key_points"], data["line_points"], data["color"])
	graph.visible = false

func show_too_many_boxes():
	var data = solutions_data["too_many"]
	title.text = data["title"]
	wzor.text = STALY_WZOR
	
	if graph.has_method("clear_solution"):
		graph.clear_solution()
	graph.visible = false

func generate_line_points_ekran2() -> PackedVector2Array:
	var points = PackedVector2Array()
	
	for i in range(0, 21):  
		var x = i * 0.1
		var y = 1 + 2*x + 0*x*(x-1) + 1*x*(x-1)*(x-2)
		points.append(Vector2(x, y))
	
	points.append(Vector2(0.0, 1.0))
	points.append(Vector2(1.0, 3.0))
	points.append(Vector2(2.0, 7.0))
	
	var points_array = []
	for point in points:
		points_array.append(point)
	
	points_array.sort_custom(func(a, b): return a.x < b.x)
	
	var result = PackedVector2Array()
	for point in points_array:
		result.append(point)
	
	return result

func generate_random_points() -> PackedVector2Array:
	var points: PackedVector2Array = []
	for i in range(-10, 11):
		var x = i * 0.2
		var y = sin(x * 2.0) * 2.0 + cos(x)
		points.append(Vector2(x, y))
	return points
