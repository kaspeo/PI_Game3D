extends Control

@export var x_min := -5.0
@export var x_max := 5.0
@export var y_min := -10.0
@export var y_max := 10.0
@export var font: Font
@export var point_count := 5  # Liczba punktów interpolacji

var points := []  # Tablica punktów w formacie [x, y]

func _ready():
	# Inicjalizacja domyślnych punktów równomiernie rozłożonych
	points = []
	for i in range(point_count):
		var x = lerp(x_min, x_max, float(i) / (point_count - 1))
		var y = 0.0
		points.append({"x": x, "y": y})
	queue_redraw()

func _draw():
	# Rysowanie osi
	var y_axis_pos = remap(0, x_min, x_max, 0, size.x)
	draw_line(Vector2(y_axis_pos, 0), Vector2(y_axis_pos, size.y), Color(1,1,1,0.8), 2)
	
	var x_axis_pos = remap(0, y_min, y_max, size.y, 0)
	draw_line(Vector2(0, x_axis_pos), Vector2(size.x, x_axis_pos), Color(1,1,1,0.8), 2)
	
	# Etykiety osi
	if font:
		draw_string(font, Vector2(size.x - 30, x_axis_pos + 20), "x")
		draw_string(font, Vector2(y_axis_pos + 5, 20), "y")
	
	# Rysowanie krzywej interpolacyjnej
	if points.size() >= 2:
		var curve_points = PackedVector2Array()
		var step := 0.01
		var t := x_min
		while t <= x_max:
			var y = lagrange(t)
			var px = remap(t, x_min, x_max, 0, size.x)
			var py = remap(y, y_min, y_max, size.y, 0)
			curve_points.append(Vector2(px, py))
			t += step

		for i in curve_points.size() - 1:
			draw_line(curve_points[i], curve_points[i+1], Color.SKY_BLUE, 2)
	
	# Rysowanie punktów interpolacji
	for p in points:
		var px = remap(p["x"], x_min, x_max, 0, size.x)
		var py = remap(p["y"], y_min, y_max, size.y, 0)
		draw_circle(Vector2(px, py), 5, Color.RED)
		
		# Etykiety punktów
		if font:
			draw_string(font, Vector2(px + 10, py - 10), "(%.1f, %.1f)" % [p["x"], p["y"]])

func lagrange(x: float) -> float:
	var result := 0.0
	for i in points.size():
		var term = points[i]["y"]
		for j in points.size():
			if j != i:
				term *= (x - points[j]["x"]) / (points[i]["x"] - points[j]["x"])
		result += term
	return result

func set_point_value(index: int, y_value: float):
	if index >= 0 and index < points.size():
		points[index]["y"] = y_value
		queue_redraw()
