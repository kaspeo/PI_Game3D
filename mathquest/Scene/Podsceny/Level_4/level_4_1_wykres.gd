extends Control
class_name GraphDrawer1

@export var graph_width: float = 850
@export var graph_height: float = 850
@export var graph_margin: float = 50.0
@export var grid_size: float = 50.0
@export var point_radius: float = 8.0

@export var grid_color: Color = Color.DIM_GRAY
@export var axis_color: Color = Color.WHITE
@export var convergent_color: Color = Color.GREEN
@export var divergent_color: Color = Color.RED
@export var function_color: Color = Color.CYAN
@export var iteration_color: Color = Color.YELLOW

@export var zoom_scale: float = 80.0
@export var focus_range: float = 2.5

var iterations_data: Array = []
var current_method: String = ""
var converges: bool = false
var root_position: float = 0.0

func _draw():
	draw_background()
	draw_grid()
	draw_axes()
	draw_function()
	draw_iterations()
	draw_labels()

func draw_background():
	draw_rect(Rect2(Vector2.ZERO, Vector2(graph_width, graph_height)), Color(0.1, 0.1, 0.1))

func setup_graph(iterations: Array, method: String, is_convergent: bool):
	iterations_data = iterations
	current_method = method
	converges = is_convergent
	
	if iterations.size() > 0:
		update_viewport()
	else:
		root_position = 0.0
		focus_range = 2.5
	
	queue_redraw()

func update_viewport():
	if iterations_data.size() < 2:
		if iterations_data.size() == 1:
			root_position = iterations_data[0].x_new
		else:
			root_position = 0.0
		focus_range = 0.5
		zoom_scale = 150.0
		return
	
	var min_x = iterations_data[0].x_new
	var max_x = iterations_data[0].x_new
	
	for it in iterations_data:
		if it.x_new < min_x:
			min_x = it.x_new
		if it.x_new > max_x:
			max_x = it.x_new
	
	root_position = (min_x + max_x) / 2.0
	
	var range = max_x - min_x
	range = max(range, 0.2)
	
	focus_range = clamp(range * 0.5, 0.2, 3.0)
	
	zoom_scale = clamp(120.0 / focus_range, 80.0, 300.0)
	
	queue_redraw()

func draw_grid():
	for x in range(int(graph_width / grid_size) + 1):
		var x_pos = x * grid_size
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, graph_height), grid_color, 0.3)
	
	for y in range(int(graph_height / grid_size) + 1):
		var y_pos = y * grid_size
		draw_line(Vector2(0, y_pos), Vector2(graph_width, y_pos), grid_color, 0.3)

func draw_axes():
	var center_x = graph_width / 2
	var center_y = graph_height / 2
	
	draw_line(Vector2(0, center_y), Vector2(graph_width, center_y), axis_color, 3.0)
	draw_line(Vector2(center_x, 0), Vector2(center_x, graph_height), axis_color, 3.0)
	
	draw_axis_arrows(center_x, center_y)

func draw_axis_arrows(center_x: float, center_y: float):
	draw_line(Vector2(graph_width - 10, center_y - 5), Vector2(graph_width, center_y), axis_color, 2.0)
	draw_line(Vector2(graph_width - 10, center_y + 5), Vector2(graph_width, center_y), axis_color, 2.0)
	
	draw_line(Vector2(center_x - 5, 10), Vector2(center_x, 0), axis_color, 2.0)
	draw_line(Vector2(center_x + 5, 10), Vector2(center_x, 0), axis_color, 2.0)

func draw_function():
	var points: PackedVector2Array = []
	var center_x = graph_width / 2
	var center_y = graph_height / 2
	
	var display_min = root_position - focus_range
	var display_max = root_position + focus_range
	
	for i in range(int(graph_width)):
		var x = display_min + (display_max - display_min) * (i / graph_width)
		var y = function_value(x)
		
		var screen_x = i
		var screen_y = center_y - y * zoom_scale
		
		if screen_y >= 0 and screen_y <= graph_height:
			points.append(Vector2(screen_x, screen_y))
	
	if points.size() > 1:
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], function_color, 3.0)

func draw_iterations():
	if iterations_data.is_empty():
		return
	
	var color = convergent_color if current_method == "e" else divergent_color
	var font = ThemeDB.fallback_font
	var font_size = 16
	var center_x = graph_width / 2
	var center_y = graph_height / 2
	
	var display_min = root_position - focus_range
	var display_max = root_position + focus_range
	
	for i in range(iterations_data.size() - 1):
		var current = iterations_data[i]
		var next = iterations_data[i + 1]
		
		var x1 = ((current.x_new - display_min) / (display_max - display_min)) * graph_width
		var y1 = center_y - function_value(current.x_new) * zoom_scale
		var x2 = ((next.x_new - display_min) / (display_max - display_min)) * graph_width
		var y2 = center_y - function_value(next.x_new) * zoom_scale
		
		if point_in_bounds(Vector2(x1, y1)) and point_in_bounds(Vector2(x2, y2)):
			draw_line(Vector2(x1, y1), Vector2(x2, y2), iteration_color, 2.5)
	
	for i in range(iterations_data.size()):
		var iter_data = iterations_data[i]
		
		var screen_x = ((iter_data.x_new - display_min) / (display_max - display_min)) * graph_width
		var screen_y = center_y - function_value(iter_data.x_new) * zoom_scale
		
		if point_in_bounds(Vector2(screen_x, screen_y)):
			draw_circle(Vector2(screen_x, screen_y), point_radius + 2, Color.BLACK)
			draw_circle(Vector2(screen_x, screen_y), point_radius, color)
			
			draw_rect(Rect2(Vector2(screen_x + 8, screen_y - 20), Vector2(20, 16)), Color.BLACK)
			draw_string(
				font,
				Vector2(screen_x + 10, screen_y - 8),
				str(i),
				HORIZONTAL_ALIGNMENT_LEFT,
				-1,
				font_size
			)

func draw_labels():
	var font = ThemeDB.fallback_font
	var font_size = 18
	
	draw_string(font, Vector2(graph_width - 25, graph_height / 2 + 25), "x", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	draw_string(font, Vector2(graph_width / 2 + 15, 25), "y", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	
	var method_text = "Metoda: " + current_method.to_upper()
	if current_method == "e":
		method_text += " (ZBIEŻNA)"
	else:
		method_text += " (ROZBIEŻNA)"
	
	draw_string(font, Vector2(20, 30), method_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	
	var display_min = root_position - focus_range
	var display_max = root_position + focus_range
	var range_text = "Zakres: [%.2f, %.2f]" % [display_min, display_max]
	draw_string(font, Vector2(20, 60), range_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

func function_value(x: float) -> float:
	return x * x * x - x - 4.5

func point_in_bounds(point: Vector2) -> bool:
	return point.x >= 0 and point.x <= graph_width and point.y >= 0 and point.y <= graph_height

func clear_graph():
	iterations_data = []
	current_method = ""
	converges = false
	root_position = 0.0
	focus_range = 2.5
	queue_redraw()
