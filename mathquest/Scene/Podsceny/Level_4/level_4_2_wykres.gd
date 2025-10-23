extends Control
class_name GraphDrawer2

@export var grid_size: float = 50.0
@export var point_radius: float = 8.0
@export var grid_color: Color = Color.DIM_GRAY
@export var axis_color: Color = Color.WHITE
@export var function_color: Color = Color.CYAN
@export var tangent_color: Color = Color.RED
@export var point_color: Color = Color.YELLOW
@export var zoom_scale: float = 40.0
@export var focus_range: float = 3.0

var iterations_data: Array = []
var current_iteration: int = 0
var function: Callable = func(x): return 0.0
var derivative: Callable = func(x): return 0.0

func _draw():
	draw_background()
	draw_grid()
	draw_axes()
	draw_function()
	draw_tangents_and_points()
	draw_labels()

func draw_background():
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.1, 0.1, 0.1))

func draw_grid():
	for x in range(int(size.x / grid_size) + 1):
		var x_pos = x * grid_size
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, size.y), grid_color, 0.5)
	for y in range(int(size.y / grid_size) + 1):
		var y_pos = y * grid_size
		draw_line(Vector2(0, y_pos), Vector2(size.x, y_pos), grid_color, 0.5)

func draw_axes():
	var center_x = size.x / 2
	var center_y = size.y / 2
	draw_line(Vector2(0, center_y), Vector2(size.x, center_y), axis_color, 2.0)
	draw_line(Vector2(center_x, 0), Vector2(center_x, size.y), axis_color, 2.0)
	draw_line(Vector2(size.x - 15, center_y - 8), Vector2(size.x, center_y), axis_color, 2.0)
	draw_line(Vector2(size.x - 15, center_y + 8), Vector2(size.x, center_y), axis_color, 2.0)
	draw_line(Vector2(center_x - 8, 15), Vector2(center_x, 0), axis_color, 2.0)
	draw_line(Vector2(center_x + 8, 15), Vector2(center_x, 0), axis_color, 2.0)

func draw_function():
	if not function:
		return
	var points: PackedVector2Array = []
	var center_x = size.x / 2
	var center_y = size.y / 2
	var display_min = -focus_range
	var display_max = focus_range
	for i in range(int(size.x)):
		var x = display_min + (display_max - display_min) * (i / size.x)
		var y = function.call(x)
		var screen_x = i
		var screen_y = center_y - y * zoom_scale
		if screen_y >= -1000 and screen_y <= size.y + 1000:
			points.append(Vector2(screen_x, screen_y))
	if points.size() > 1:
		var visible_segments = []
		var current_segment = []
		for i in range(points.size()):
			var point = points[i]
			if point.y >= -100 and point.y <= size.y + 100:
				current_segment.append(point)
			else:
				if current_segment.size() > 1:
					visible_segments.append(current_segment.duplicate())
				current_segment.clear()
		if current_segment.size() > 1:
			visible_segments.append(current_segment)
		for segment in visible_segments:
			for i in range(segment.size() - 1):
				draw_line(segment[i], segment[i + 1], function_color, 3.0)

func draw_tangents_and_points():
	if iterations_data.is_empty():
		return
	var center_x = size.x / 2
	var center_y = size.y / 2
	var display_min = -focus_range
	var display_max = focus_range
	for i in range(min(iterations_data.size(), current_iteration + 1)):
		var iter_data = iterations_data[i]
		var x = iter_data.x
		var fx = iter_data.fx
		var dfx = iter_data.dfx
		var point_x = ((x - display_min) / (display_max - display_min)) * size.x
		var point_y = center_y - fx * zoom_scale
		if point_in_bounds(Vector2(point_x, point_y)):
			draw_tangent_line(x, fx, dfx, center_x, center_y, display_min, display_max)
			draw_circle(Vector2(point_x, point_y), point_radius + 2, Color.BLACK)
			draw_circle(Vector2(point_x, point_y), point_radius, point_color)
			draw_string(ThemeDB.fallback_font, Vector2(point_x + 12, point_y - 12), "x%d" % i, HORIZONTAL_ALIGNMENT_LEFT, -1, 14)

func draw_tangent_line(x: float, fx: float, dfx: float, center_x: float, center_y: float, display_min: float, display_max: float):
	var tangent_points: PackedVector2Array = []
	var tangent_length = 1.5
	for j in range(int(size.x)):
		var tangent_x = display_min + (display_max - display_min) * (j / size.x)
		if abs(tangent_x - x) <= tangent_length:
			var tangent_y = fx + dfx * (tangent_x - x)
			var screen_x = j
			var screen_y = center_y - tangent_y * zoom_scale
			if screen_y >= -100 and screen_y <= size.y + 100:
				tangent_points.append(Vector2(screen_x, screen_y))
	if tangent_points.size() > 1:
		for j in range(tangent_points.size() - 1):
			draw_line(tangent_points[j], tangent_points[j + 1], tangent_color, 2.0)

func draw_labels():
	var font = ThemeDB.fallback_font
	var font_size = 16
	draw_string(font, Vector2(size.x - 25, size.y / 2 + 25), "x", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	draw_string(font, Vector2(size.x / 2 + 15, 25), "y", HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var title = "Metoda Newtona - Iteracja: %d/%d" % [current_iteration + 1, iterations_data.size()]
	draw_string(font, Vector2(20, 30), title, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var range_text = "Zakres: [%.1f, %.1f]" % [-focus_range, focus_range]
	draw_string(font, Vector2(20, 55), range_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

func point_in_bounds(point: Vector2) -> bool:
	return point.x >= 0 and point.x <= size.x and point.y >= 0 and point.y <= size.y

func setup_newton_graph(iterations: Array, func_callable: Callable, deriv_callable: Callable):
	iterations_data = iterations
	function = func_callable
	derivative = deriv_callable
	current_iteration = iterations.size() - 1
	queue_redraw()

func set_current_iteration(iter: int):
	current_iteration = clamp(iter, 0, iterations_data.size() - 1)
	queue_redraw()

func clear_graph():
	iterations_data = []
	current_iteration = 0
	function = func(x): return 0.0
	derivative = func(x): return 0.0
	queue_redraw()
