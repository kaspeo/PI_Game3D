extends Control

@onready var title: Label = $VBoxContainer/Title
@onready var graph: ColorRect = $VBoxContainer/Graph
@onready var wzor: Label = $VBoxContainer/Wzor

var solutions_data = {
	"empty": {
		"title": "EKRAŃ INTERPOLACJI HERMITE'A",
		"wzor": "Umieść 3 pudełka z danymi w obszarze ekranu",
		"key_points": PackedVector2Array(),
		"line_points": PackedVector2Array()
	},
	"correct": {
		"title": "INTERPOLACJA HERMITE'A - POPRAWNA",
		"wzor": "W₃(x) = -8 + 6·(x + 1) - 5·(x + 1)x + 1·(x + 1)x²",
		"key_points": PackedVector2Array([
			Vector2(-1, -8),
			Vector2(0, -2), 
			Vector2(1, -4)
		]),
		"line_points": generate_line_points_ekran1(),
		"color": Color.GREEN
	},
	"incorrect": {
		"title": "INTERPOLACJA HERMITE'A - BŁĘDNA",
		"wzor": "Kombinacja pudełek jest niepoprawna",
		"key_points": PackedVector2Array([
			Vector2(-1, 2),
			Vector2(0, 0),
			Vector2(1, 1)
		]),
		"line_points": generate_random_points(),
		"color": Color.RED
	},
	"too_many": {
		"title": "ZA DUŻO PUDEŁEK!",
		"wzor": "Możesz umieścić tylko 3 pudełka na ekranie",
		"key_points": PackedVector2Array(),
		"line_points": PackedVector2Array(),
		"color": Color.ORANGE
	}
}

func _ready():
	show_empty()

func show_empty():
	var data = solutions_data["empty"]
	title.text = data["title"]
	wzor.text = data["wzor"]
	
	if graph.has_method("clear_solution"):
		graph.clear_solution()
	graph.visible = false

func show_correct_solution():
	var data = solutions_data["correct"]
	title.text = data["title"]
	wzor.text = data["wzor"]
	
	if graph.has_method("draw_solution"):
		graph.draw_solution(data["key_points"], data["line_points"], data["color"])
	graph.visible = true

func show_incorrect_solution():
	var data = solutions_data["incorrect"]
	title.text = data["title"]
	wzor.text = data["wzor"]
	
	if graph.has_method("draw_solution"):
		graph.draw_solution(data["key_points"], data["line_points"], data["color"])
	graph.visible = false

func show_too_many_boxes():
	var data = solutions_data["too_many"]
	title.text = data["title"]
	wzor.text = data["wzor"]
	
	if graph.has_method("clear_solution"):
		graph.clear_solution()
	graph.visible = false

func generate_line_points_ekran1() -> PackedVector2Array:
	var points: PackedVector2Array = []
	for i in range(-10, 11):
		var x = i * 0.2
		var y = -8 + 6*(x+1) - 5*(x+1)*x + 1*(x+1)*x*x
		points.append(Vector2(x, y))
	return points

func generate_random_points() -> PackedVector2Array:
	var points: PackedVector2Array = []
	for i in range(-10, 11):
		var x = i * 0.2
		var y = sin(x * 2.0) * 2.0 + cos(x)
		points.append(Vector2(x, y))
	return points
