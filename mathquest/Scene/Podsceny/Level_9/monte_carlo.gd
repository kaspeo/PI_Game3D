extends ColorRect

class_name UniversalFunctionGraph

var current_function: String = ""
var integration_limits: Array = [0.0, 1.0]
var visualization_type: String = "monte_carlo"
var monte_carlo_points: Array = []

func _ready():
	queue_redraw()

func set_problem(func_str: String, limits: Array):
	current_function = func_str
	integration_limits = limits
	queue_redraw()

func set_monte_carlo_points(points: Array):
	monte_carlo_points = points
	queue_redraw()

func update_visualization(type: String, count: int):
	visualization_type = type
	# Nie generujemy tutaj punktów - punkty są przekazywane z głównego skryptu
	queue_redraw()

func _draw():
	if integration_limits.size() != 2:
		return
		
	var size = get_rect().size
	var margin = 20
	var graph_width = size.x - 2 * margin
	var graph_height = size.y - 2 * margin
	
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.1, 0.1, 0.2))
	
	# Osie
	draw_line(Vector2(margin, size.y - margin), Vector2(size.x - margin, size.y - margin), Color.WHITE, 2)
	draw_line(Vector2(margin, margin), Vector2(margin, size.y - margin), Color.WHITE, 2)
	
	var a = integration_limits[0]
	var b = integration_limits[1]
	var scale_x = graph_width / (b - a)
	
	# Skalowanie Y
	var max_y = find_max_function_value()
	var min_y = find_min_function_value()
	var y_range = max_y - min_y
	
	if y_range == 0:
		y_range = 1.0
		
	var scale_y = graph_height / (y_range * 1.2)
	var y_offset = -min_y
	
	# Rysuj funkcję
	draw_function(scale_x, scale_y, margin, graph_height, y_offset)
	
	# Rysuj punkty Monte Carlo
	draw_monte_carlo_points(scale_x, scale_y, margin, graph_height, y_offset)

func draw_function(scale_x: float, scale_y: float, margin: float, graph_height: float, y_offset: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	
	var points = PackedVector2Array()
	for i in range(size.x - 2 * margin):
		var x_pixel = i + margin
		var x = a + (i / float(size.x - 2 * margin)) * (b - a)
		var y = evaluate_function(x)
		var y_pixel = size.y - margin - ((y + y_offset) * scale_y)
		points.append(Vector2(x_pixel, y_pixel))
	
	if points.size() > 1:
		draw_polyline(points, Color.GREEN, 2)

func draw_monte_carlo_points(scale_x: float, scale_y: float, margin: float, graph_height: float, y_offset: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var max_y = find_max_function_value()
	var min_y = find_min_function_value()
	
	# Rysuj prostokąt całkowania
	var rect_top = size.y - margin - ((max_y + y_offset) * scale_y)
	var rect_bottom = size.y - margin - ((min_y + y_offset) * scale_y)
	var rect_height = rect_bottom - rect_top
	
	draw_rect(Rect2(
		margin, 
		rect_top, 
		size.x - 2 * margin, 
		rect_height
	), Color(1, 1, 1, 0.1), false, 2.0)
	
	# Rysuj oś X
	var zero_y = size.y - margin - ((0 + y_offset) * scale_y)
	draw_line(
		Vector2(margin, zero_y),
		Vector2(size.x - margin, zero_y),
		Color(1, 1, 1, 0.5),
		1.0
	)
	
	for point in monte_carlo_points:
		var x_pixel = margin + (point["x"] - a) * scale_x
		var y_pixel = size.y - margin - ((point["y"] + y_offset) * scale_y)
		
		var color = Color.GREEN if point["inside"] else Color.RED
		var size_point = 3 if point["inside"] else 2
		
		draw_circle(Vector2(x_pixel, y_pixel), size_point, color)

func find_max_function_value() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var max_val = -INF
	
	for i in range(100):
		var x = a + (b - a) * i / 100.0
		max_val = max(max_val, evaluate_function(x))
	
	return max(0.1, max_val)

func find_min_function_value() -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var min_val = INF
	
	for i in range(100):
		var x = a + (b - a) * i / 100.0
		min_val = min(min_val, evaluate_function(x))
	
	return min(-0.1, min_val)

func evaluate_function(x: float) -> float:
	return exp(-x/2.0) * sin(3.0 * x) * cos(2.0 * x)
