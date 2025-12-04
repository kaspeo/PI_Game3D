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
	draw_rect(Rect2(Vector2.ZERO, size + Vector2.ONE), Color(0.1, 0.1, 0.1))

func draw_grid():
	for x in range(int(size.x / grid_size)):
		var x_pos = x * grid_size
		draw_line(Vector2(x_pos, 0), Vector2(x_pos, size.y), grid_color, 0.5)
	for y in range(int(size.y / grid_size)):
		var y_pos = y * grid_size
		draw_line(Vector2(0, y_pos), Vector2(size.x, y_pos), grid_color, 0.5)

func draw_axes():
	var cx = size.x / 2
	var cy = size.y / 2
	draw_line(Vector2(0, cy), Vector2(size.x, cy), axis_color, 2)
	draw_line(Vector2(cx, 0), Vector2(cx, size.y), axis_color, 2)
	draw_line(Vector2(size.x - 15, cy - 8), Vector2(size.x, cy), axis_color, 2)
	draw_line(Vector2(size.x - 15, cy + 8), Vector2(size.x, cy), axis_color, 2)
	draw_line(Vector2(cx - 8, 15), Vector2(cx, 0), axis_color, 2)
	draw_line(Vector2(cx + 8, 15), Vector2(cx, 0), axis_color, 2)

func draw_function():
	if not function:
		return
	var cx = size.x / 2
	var cy = size.y / 2
	var min_x = -focus_range
	var max_x = focus_range
	var points := PackedVector2Array()
	for px in range(int(size.x)):
		var x = min_x + (max_x - min_x) * (px / size.x)
		var y = function.call(x)
		var sy = cy - y * zoom_scale
		if sy >= 0 and sy <= size.y:
			points.append(Vector2(px, sy))
	if points.size() > 1:
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], function_color, 3.0)

func draw_tangents_and_points():
	if iterations_data.is_empty():
		return
	var cx = size.x / 2
	var cy = size.y / 2
	var min_x = -focus_range
	var max_x = focus_range
	for i in range(min(iterations_data.size(), current_iteration + 1)):
		var it = iterations_data[i]
		var x = it.x
		var fx = it.fx
		var dfx = it.dfx
		var px = ((x - min_x) / (max_x - min_x)) * size.x
		var py = cy - fx * zoom_scale
		if px >= 0 and px <= size.x and py >= 0 and py <= size.y:
			draw_tangent_line(x, fx, dfx, cx, cy, min_x, max_x)
			draw_circle(Vector2(px, py), point_radius + 2, Color.BLACK)
			draw_circle(Vector2(px, py), point_radius, point_color)
			draw_string(ThemeDB.fallback_font, Vector2(px + 12, py - 12), "x%d" % i)

func draw_tangent_line(x, fx, dfx, cx, cy, min_x, max_x):
	var points := PackedVector2Array()
	for px in range(int(size.x)):
		var tx = min_x + (max_x - min_x) * (px / size.x)
		var ty = fx + dfx * (tx - x)
		var sy = cy - ty * zoom_scale
		if sy >= 0 and sy <= size.y:
			points.append(Vector2(px, sy))
	if points.size() > 1:
		for i in range(points.size() - 1):
			draw_line(points[i], points[i + 1], tangent_color, 2.0)

func draw_labels():
	var font = ThemeDB.fallback_font
	draw_string(font, Vector2(size.x - 25, size.y / 2 + 25), "x")
	draw_string(font, Vector2(size.x / 2 + 15, 25), "y")
	var title = "Metoda Newtona - Iteracja: %d/%d" % [current_iteration + 1, iterations_data.size()]
	draw_string(font, Vector2(20, 30), title)
	var range_text = "Zakres: [%.1f, %.1f]" % [-focus_range, focus_range]
	draw_string(font, Vector2(20, 55), range_text)

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
