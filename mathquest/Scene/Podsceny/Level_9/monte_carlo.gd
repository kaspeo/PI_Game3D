extends ColorRect

class_name VolumeOfRevolution

var current_function: String = "x"
var integration_limits: Array = [0.0, 1.0]
var visualization_type: String = "disk"
var num_elements: int = 8
var rotation_axis: String = "x"  # "x" lub "y"

func _ready():
	queue_redraw()

func set_problem(func_str: String, limits: Array):
	current_function = func_str
	integration_limits = limits
	queue_redraw()

func update_visualization(type: String, count: int):
	visualization_type = type
	num_elements = count
	queue_redraw()

func set_rotation_axis(axis: String):
	rotation_axis = axis
	queue_redraw()

func _draw():
	if integration_limits.size() != 2:
		return
		
	var size = get_rect().size
	var margin = 50
	var graph_width = size.x - 2 * margin
	var graph_height = size.y - 2 * margin
	
	draw_rect(Rect2(0, 0, size.x, size.y), Color(0.1, 0.1, 0.2))
	
	match visualization_type:
		"disk":
			draw_disk_method(margin, graph_width, graph_height)
		"shell":
			draw_shell_method(margin, graph_width, graph_height)
		"3d_preview":
			draw_3d_preview(margin, graph_width, graph_height)

func draw_disk_method(margin: float, width: float, height: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = num_elements
	var h = (b - a) / n
	
	# Rysuj oś obrotu
	if rotation_axis == "x":
		draw_line(Vector2(margin, size.y/2), Vector2(size.x - margin, size.y/2), Color.YELLOW, 3.0)
	else:
		draw_line(Vector2(size.x/2, margin), Vector2(size.x/2, size.y - margin), Color.YELLOW, 3.0)
	
	# Rysuj dyski/walcowe elementy
	for i in range(n):
		var x = a + i * h
		var x_next = a + (i + 1) * h
		var radius = evaluate_function(x)
		var radius_next = evaluate_function(x_next)
		
		if rotation_axis == "x":
			# Obrót wokół osi X - tworzy dyski
			var disk_center_x = margin + (x - a) * (width / (b - a))
			var disk_width = h * (width / (b - a))
			var disk_radius = abs(radius) * (height / 4.0)
			
			# Dysk
			draw_circle(Vector2(disk_center_x + disk_width/2, size.y/2), disk_radius, Color(1, 0, 0, 0.3))
			draw_arc(Vector2(disk_center_x + disk_width/2, size.y/2), disk_radius, 0, TAU, 32, Color.RED, 2.0)
			
			# Linie łączące z osią
			draw_line(Vector2(disk_center_x + disk_width/2, size.y/2 - disk_radius), 
					 Vector2(disk_center_x + disk_width/2, size.y/2 + disk_radius), 
					 Color(1, 1, 1, 0.5), 1.0)
		else:
			# Obrót wokół osi Y - tworzy cylindry/pierścienie
			var disk_center_y = size.y/2
			var disk_height = h * (height / (b - a))
			var disk_radius = abs(radius) * (width / 4.0)
			
			# Cylinder
			draw_arc(Vector2(size.x/2, margin + i * disk_height + disk_height/2), disk_radius, -PI/2, PI/2, 16, Color.BLUE, 2.0)
			draw_arc(Vector2(size.x/2, margin + i * disk_height + disk_height/2), disk_radius, PI/2, 3*PI/2, 16, Color.BLUE, 2.0)
			draw_line(Vector2(size.x/2 - disk_radius, margin + i * disk_height), 
					 Vector2(size.x/2 - disk_radius, margin + i * disk_height + disk_height), 
					 Color.BLUE, 2.0)
			draw_line(Vector2(size.x/2 + disk_radius, margin + i * disk_height), 
					 Vector2(size.x/2 + disk_radius, margin + i * disk_height + disk_height), 
					 Color.BLUE, 2.0)

func draw_shell_method(margin: float, width: float, height: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	var n = num_elements
	var h = (b - a) / n
	
	# Rysuj oś obrotu
	draw_line(Vector2(size.x/2, margin), Vector2(size.x/2, size.y - margin), Color.YELLOW, 3.0)
	
	# Rysuj powłoki walcowe
	for i in range(n):
		var x = a + i * h
		var radius = x
		var height_shell = evaluate_function(x)
		var shell_thickness = h * (width / (b - a))
		
		var shell_center_x = size.x/2
		var shell_radius = abs(radius) * (width / (b - a)) * 0.8
		var shell_height = abs(height_shell) * (height / 4.0)
		
		# Powłoka walcowa
		draw_arc(Vector2(shell_center_x, size.y/2), shell_radius, -PI/2, PI/2, 16, Color.GREEN, 2.0)
		draw_arc(Vector2(shell_center_x, size.y/2), shell_radius + shell_thickness, -PI/2, PI/2, 16, Color.GREEN, 2.0)
		
		# Linie łączące
		draw_line(Vector2(shell_center_x - shell_radius, size.y/2 - shell_height),
				 Vector2(shell_center_x - shell_radius - shell_thickness, size.y/2 - shell_height),
				 Color.GREEN, 2.0)
		draw_line(Vector2(shell_center_x - shell_radius, size.y/2 + shell_height),
				 Vector2(shell_center_x - shell_radius - shell_thickness, size.y/2 + shell_height),
				 Color.GREEN, 2.0)

func draw_3d_preview(margin: float, width: float, height: float):
	var size = get_rect().size
	var a = integration_limits[0]
	var b = integration_limits[1]
	
	# Rysuj prostą wizualizację 3D bryły obrotowej
	var center = Vector2(size.x/2, size.y/2)
	var max_radius = 0.0
	
	# Znajdź maksymalny promień
	for i in range(100):
		var x = a + (b - a) * i / 100.0
		max_radius = max(max_radius, abs(evaluate_function(x)))
	
	var scale = min(width, height) / (max_radius * 2.5)
	
	# Rysuj kontur bryły
	var points = PackedVector2Array()
	for i in range(72):  # 72 punkty dla gładkiego okręgu
		var angle = i * TAU / 72
		var x = a + (b - a) * i / 72.0
		var radius = evaluate_function(x)
		var point = center + Vector2(cos(angle) * radius * scale, sin(angle) * radius * scale * 0.7)  # Skalowanie dla efektu 3D
		points.append(point)
	
	if points.size() > 1:
		draw_polyline(points, Color.CYAN, 3.0)
	
	# Rysuj linie przekroju
	for i in range(0, 72, 12):
		var angle = i * TAU / 72
		var x = a + (b - a) * i / 72.0
		var radius = evaluate_function(x)
		var point = center + Vector2(cos(angle) * radius * scale, sin(angle) * radius * scale * 0.7)
		draw_line(center, point, Color(1, 1, 1, 0.3), 1.0)

func calculate_volume_disk_method(n: int) -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var h = (b - a) / n
	var volume = 0.0
	
	for i in range(n):
		var x = a + i * h
		var radius = evaluate_function(x)
		volume += PI * radius * radius * h
	
	return volume

func calculate_volume_shell_method(n: int) -> float:
	var a = integration_limits[0]
	var b = integration_limits[1]
	var h = (b - a) / n
	var volume = 0.0
	
	for i in range(n):
		var x = a + i * h
		var radius = x
		var height = evaluate_function(x)
		volume += 2 * PI * radius * height * h
	
	return volume

func get_volume_info() -> Dictionary:
	var disk_volume = calculate_volume_disk_method(1000)
	var shell_volume = calculate_volume_shell_method(1000)
	
	return {
		"disk_method": disk_volume,
		"shell_method": shell_volume,
		"exact": calculate_exact_volume()
	}

func calculate_exact_volume() -> float:
	# Dla funkcji x^2 od 0 do 1, objętość = π/5
	if current_function == "x*x" and integration_limits[0] == 0 and integration_limits[1] == 1:
		return PI / 5.0
	# Dla funkcji x od 0 do 1, objętość = π/3
	elif current_function == "x" and integration_limits[0] == 0 and integration_limits[1] == 1:
		return PI / 3.0
	else:
		return calculate_volume_disk_method(5000)  # Wysoka precyzja

func evaluate_function(x: float) -> float:
	match current_function:
		"x":
			return x
		"x*x":
			return x * x
		"sqrt(x)":
			return sqrt(x)
		"sin(x)":
			return sin(x)
		"1":
			return 1.0
		_:
			return x  # Domyślnie funkcja liniowa
