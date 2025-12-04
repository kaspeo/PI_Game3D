extends ColorRect

var current_function: String = ""
var integration_limits: Array = [0.0, 1.0]
var visualization_type: String = "rectangles"
var num_elements: int = 4

func _ready():
	queue_redraw()

func set_problem(func_str: String, limits: Array):
	current_function = func_str
	integration_limits = limits
	queue_redraw()

func update_visualization(type: String, count: int):
	visualization_type = type
	num_elements = count
	if visualization_type == "simpson" and num_elements % 2 != 0:
		num_elements += 1 
	queue_redraw()

func _draw():
	if integration_limits.size() != 2:
		return
	
	var size = get_rect().size
	var margin = 0.0
	var graph_width = size.x - 2 * margin
	var graph_height = size.y - 2 * margin
	
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.1, 0.1, 0.2))
	
	draw_line(Vector2(margin, size.y - margin), Vector2(size.x - margin, size.y - margin), Color.WHITE, 2)
	draw_line(Vector2(margin, margin), Vector2(margin, size.y - margin), Color.WHITE, 2)
	
	var a = integration_limits[0]
	var b = integration_limits[1]
	var scale_x = graph_width / (b - a)
	
	var max_y = 0.0
	for i in range(100):
		var x = a + (b - a) * i / 100.0
		max_y = max(max_y, abs(evaluate_function(x)))
	
	if max_y == 0:
		max_y = 1.0
		
	var scale_y = graph_height / (max_y * 2.2)
	
	draw_function(scale_x, scale_y, margin, graph_height)
	
	match visualization_type:
		"rectangles":
			draw_rectangles(scale_x, scale_y, margin, graph_height)
		"simpson":
			draw_simpson_parabolas(scale_x, scale_y, margin, graph_height)

func draw_function(scale_x: float, scale_y: float, margin: float, graph_height: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	
	var points = PackedVector2Array()
	for i in range(size.x):
		var x_pixel = i
		var x = a + (i / float(size.x)) * (b - a)
		var y = evaluate_function(x)
		var y_pixel = size.y - (y * scale_y + graph_height / 2)
		points.append(Vector2(x_pixel, y_pixel))
	
	if points.size() > 1:
		draw_polyline(points, Color.GREEN, 2)

func draw_rectangles(scale_x: float, scale_y: float, margin: float, graph_height: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = num_elements
	var h = (b - a) / n
	
	for i in range(n):
		var x_mid = a + (i + 0.5) * h
		var y_mid = evaluate_function(x_mid)
		
		var rect_x = margin + i * h * scale_x
		var rect_width = h * scale_x
		var rect_height = y_mid * scale_y
		var rect_y = size.y - graph_height / 2 - rect_height
		
		draw_rect(Rect2(rect_x, rect_y, rect_width, rect_height), Color(1, 0, 0, 0.3))
		draw_rect(Rect2(rect_x, rect_y, rect_width, rect_height), Color.RED, false, 1.0)
		
		var mid_x = rect_x + rect_width / 2
		var mid_y = rect_y + rect_height
		draw_circle(Vector2(mid_x, mid_y), 3, Color.YELLOW)

func draw_simpson_parabolas(scale_x: float, scale_y: float, margin: float, graph_height: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = num_elements
	var h = (b - a) / n
	
	for i in range(n + 1):
		var x = a + i * h
		var x_pixel = margin + (x - a) * scale_x
		
		var y_func = evaluate_function(x)
		var y_pixel_func = size.y - (y_func * scale_y + graph_height / 2)
		var y_pixel_axis = size.y - graph_height / 2
		
		draw_line(
			Vector2(x_pixel, y_pixel_axis),
			Vector2(x_pixel, y_pixel_func),
			Color(0.5, 0.5, 0.5, 0.6),
			1.0
		)
		
		draw_circle(Vector2(x_pixel, y_pixel_func), 3, Color.YELLOW)
	
	for i in range(0, n, 2):
		if i + 2 > n:
			break
			
		var x0 = a + i * h
		var x1 = a + (i + 1) * h
		var x2 = a + (i + 2) * h
		
		var y0 = evaluate_function(x0)
		var y1 = evaluate_function(x1)
		var y2 = evaluate_function(x2)
		
		var parabola_points = PackedVector2Array()
		for j in range(21):
			var t = j / 20.0
			var x = x0 + t * (2 * h)
			var y = lagrange_interpolation(x, x0, x1, x2, y0, y1, y2)
			
			var x_pixel = margin + (x - a) * scale_x
			var y_pixel = size.y - (y * scale_y + graph_height / 2)
			parabola_points.append(Vector2(x_pixel, y_pixel))
		
		if parabola_points.size() > 1:
			draw_polyline(parabola_points, Color(1, 0.5, 0), 2)
		
		
		var segment1_points = PackedVector2Array()
		segment1_points.append(Vector2(margin + (x0 - a) * scale_x, size.y - graph_height / 2))
		
		for j in range(0, 11):
			segment1_points.append(parabola_points[j])
		
		segment1_points.append(Vector2(margin + (x1 - a) * scale_x, size.y - graph_height / 2))
		
		if segment1_points.size() >= 3:
			draw_colored_polygon(segment1_points, Color(1, 0.3, 0, 0.4)) 
		
		var segment2_points = PackedVector2Array()
		segment2_points.append(Vector2(margin + (x1 - a) * scale_x, size.y - graph_height / 2)) 
		
		for j in range(10, 21):  
			segment2_points.append(parabola_points[j])
		
		segment2_points.append(Vector2(margin + (x2 - a) * scale_x, size.y - graph_height / 2)) 
		
		if segment2_points.size() >= 3:
			draw_colored_polygon(segment2_points, Color(1, 0.7, 0, 0.4))
		
		draw_circle(Vector2(margin + (x0 - a) * scale_x, size.y - (y0 * scale_y + graph_height / 2)), 4, Color.CYAN)
		draw_circle(Vector2(margin + (x1 - a) * scale_x, size.y - (y1 * scale_y + graph_height / 2)), 4, Color.CYAN)
		draw_circle(Vector2(margin + (x2 - a) * scale_x, size.y - (y2 * scale_y + graph_height / 2)), 4, Color.CYAN)
	
	draw_line(
		Vector2(margin, size.y - graph_height / 2),
		Vector2(size.x - margin, size.y - graph_height / 2),
		Color(1, 1, 1, 0.3),
		1.0
	)
	
	for i in range(n + 1):
		var x = a + i * h
		var x_pixel = margin + (x - a) * scale_x
		var y_top = margin
		var y_bottom = size.y
		
		draw_line(
			Vector2(x_pixel, y_top),
			Vector2(x_pixel, y_bottom),
			Color(1, 1, 1, 0.2),
			1.0
		)

func lagrange_interpolation(x: float, x0: float, x1: float, x2: float, y0: float, y1: float, y2: float) -> float:
	var term1 = y0 * (x - x1) * (x - x2) / ((x0 - x1) * (x0 - x2))
	var term2 = y1 * (x - x0) * (x - x2) / ((x1 - x0) * (x1 - x2))
	var term3 = y2 * (x - x0) * (x - x1) / ((x2 - x0) * (x2 - x1))
	return term1 + term2 + term3

func evaluate_function(x: float) -> float:
	return exp(-x/2.0) * sin(3.0 * x) * cos(2.0 * x)
