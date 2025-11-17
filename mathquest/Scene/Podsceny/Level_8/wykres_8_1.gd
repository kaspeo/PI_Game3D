extends Control

@onready var title: Label = $VBoxContainer/Title
@onready var graph: ColorRect = $VBoxContainer/Graph
@onready var wzor: Label = $VBoxContainer/Wzor

# Zostawiamy tylko dane dla poprawnego rozwiązania
var solutions_data = {
	"correct": {
		"title": "INTERPOLACJA HERMITE'A - POPRAWNA",
		"wzor": "W₃(x) = -8 + 6·(x + 1) - 5·(x + 1)x + 1·(x + 1)x²",
		"key_points": [
			Vector2(-1, -8),
			Vector2(0, -2), 
			Vector2(1, -4)
		] as Array[Vector2],
		"color": Color.GREEN
	}
}

# Dane dla stanu domyślnego (ukrytego)
var default_title = "EKRAŃ INTERPOLACJI HERMITE'A"
var default_wzor = "Umieść 3 pudełka z danymi w obszarze ekranu"

func _ready():
	# Na starcie pokaż stan domyślny (wykres ukryty)
	hide_solution()

func show_correct_solution():
	var data = solutions_data["correct"]
	
	title.text = data["title"]
	wzor.text = data["wzor"]
	
	if not graph.has_method("draw_solution"):
		return
		
	var key_points = data["key_points"]
	var line_points = _generate_correct_line_points(-1.5, 1.5, 0.05)
	
	graph.draw_solution(key_points, line_points, data["color"])
	graph.visible = true

func hide_solution():
	title.text = default_title
	wzor.text = default_wzor
	
	if graph.has_method("clear_solution"):
		graph.clear_solution()
	graph.visible = false

func _generate_correct_line_points(start_x: float, end_x: float, step: float) -> Array[Vector2]:
	var points := [] as Array[Vector2]
	
	var x = start_x
	while x <= end_x:
		var y = -8.0 + 6.0*(x + 1.0) - 5.0*(x + 1.0)*x + 1.0*(x + 1.0)*x*x
		points.append(Vector2(x, y))
		x += step
	
	if not is_equal_approx(x - step, end_x):
		var x_end = end_x
		var y_end = -8.0 + 6.0*(x_end + 1.0) - 5.0*(x_end + 1.0)*x_end + 1.0*(x_end + 1.0)*x_end*x_end
		points.append(Vector2(x_end, y_end))
		
	return points
