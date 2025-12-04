extends ColorRect

var key_points_to_draw: PackedVector2Array = []
var line_points_to_draw: PackedVector2Array = []
var current_color: Color = Color.WHITE

@export var pixels_per_unit := 50.0
@export var point_radius := 5.0
@export var axis_color := Color(0.7, 0.7, 0.7)
@export var grid_color := Color(0.4, 0.4, 0.4)
@export var font_color := Color(0.9, 0.9, 0.9)

func draw_solution(key_points: PackedVector2Array, line_points: PackedVector2Array, line_color: Color):
	key_points_to_draw = key_points
	line_points_to_draw = line_points
	current_color = line_color
	queue_redraw()

func clear_solution():
	key_points_to_draw = []
	line_points_to_draw = []
	queue_redraw()

func _draw():
	var center = size * 0.5
	
	var x = center.x + pixels_per_unit
	while x < size.x:
		draw_line(Vector2(x, 0), Vector2(x, size.y), grid_color, 1)
		x += pixels_per_unit
	x = center.x - pixels_per_unit
	while x > 0:
		draw_line(Vector2(x, 0), Vector2(x, size.y), grid_color, 1)
		x -= pixels_per_unit
	var y = center.y + pixels_per_unit
	while y < size.y:
		draw_line(Vector2(0, y), Vector2(size.x, y), grid_color, 1)
		y += pixels_per_unit
	y = center.y - pixels_per_unit
	while y > 0:
		draw_line(Vector2(0, y), Vector2(size.x, y), grid_color, 1)
		y -= pixels_per_unit
	
	draw_line(Vector2(0, center.y), Vector2(size.x, center.y), axis_color, 2)
	draw_line(Vector2(center.x, 0), Vector2(center.x, size.y), axis_color, 2)
	
	if line_points_to_draw.size() >= 2:
		print("Drawing ", line_points_to_draw.size(), " line points")
		for i in range(line_points_to_draw.size() - 1):
			var p1 = line_points_to_draw[i]
			var p2 = line_points_to_draw[i + 1]
			
			if (abs(p1.x - 2.0) < 0.001 and abs(p1.y - 7.0) < 0.001) or \
			   (abs(p2.x - 2.0) < 0.001 and abs(p2.y - 7.0) < 0.001):
				print("Line segment near (2,7): ", p1, " -> ", p2)
			
			var s1 = Vector2(center.x + p1.x * pixels_per_unit, center.y - p1.y * pixels_per_unit)
			var s2 = Vector2(center.x + p2.x * pixels_per_unit, center.y - p2.y * pixels_per_unit)
			draw_line(s1, s2, current_color, 3)
	
	var default_font = get_theme_default_font()
	var default_font_size = get_theme_default_font_size()
	
	for p in key_points_to_draw:
		var sp = Vector2(center.x + p.x * pixels_per_unit, center.y - p.y * pixels_per_unit)
		draw_circle(sp, point_radius, current_color)
		
		var text = "(%.1f, %.1f)" % [p.x, p.y]
		var text_pos = sp + Vector2(point_radius + 4, point_radius)
		draw_string(default_font, text_pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size, font_color)
