extends Control
class_name FunctionPlotter

var current_function: Callable
var roots: Array[float] = []

func _ready() -> void:
	custom_minimum_size = Vector2(400, 300)

func _draw() -> void:
	draw_rect(Rect2(0, 0, size.x, size.y), Color.SKY_BLUE)
	
	draw_line(Vector2(50, size.y/2), Vector2(size.x-50, size.y/2), Color.BLACK, 2.0)
	draw_line(Vector2(size.x/2, 50), Vector2(size.x/2, size.y-50), Color.BLACK, 2.0)
	
	if current_function != null:
		draw_function()
	
	for root in roots:
		var x = size.x/2 + root * 50
		var y = size.y/2
		draw_circle(Vector2(x, y), 5, Color.RED)

func draw_function() -> void:
	var points: PackedVector2Array = []
	
	for i in range(50, size.x - 50):
		var x = (i - size.x/2.0) / 50.0
		var y = current_function.call(x)
		
		if not is_nan(y) and not is_inf(y):
			var y_pixel = size.y/2 - y * 50
			if y_pixel > 50 and y_pixel < size.y - 50:
				points.append(Vector2(i, y_pixel))
	
	if points.size() > 1:
		draw_polyline(points, Color.BLUE, 2.0)

func set_function(func_callable: Callable) -> void:
	current_function = func_callable
	roots.clear()
	queue_redraw()

func add_root(x: float) -> void:
	roots.append(x)
	queue_redraw()

func clear_roots() -> void:
	roots.clear()
	queue_redraw()
