extends Node2D

@onready var cable: Line2D = $Line2D
@onready var grid: Line2D = $Grid
@onready var h_slider_m_0: HSlider = $VBoxContainer/HSliderM0
@onready var h_slider_m_1: HSlider = $VBoxContainer/HSliderM1

var p0: Vector2 = Vector2(100, 250)  # Dostosowane do większego ekranu
var p1: Vector2 = Vector2(1000, 250) # Dostosowane do większego ekranu
var m0: Vector2 = Vector2(0, -100)
var m1: Vector2 = Vector2(0, -100)

func _ready():
	# Konfiguracja kabla
	cable.width = 8
	cable.default_color = Color.RED
	
	# Konfiguracja siatki
	create_grid()
	
	# Konfiguracja suwaków
	h_slider_m_0.min_value = -500  # Zwiększony zakres
	h_slider_m_0.max_value = 500
	h_slider_m_0.value = m0.y
	
	h_slider_m_1.min_value = -500  # Zwiększony zakres
	h_slider_m_1.max_value = 500
	h_slider_m_1.value = m1.y
	
	# Podłączenie sygnałów suwaków
	h_slider_m_0.value_changed.connect(_on_h_slider_m_0_value_changed)
	h_slider_m_1.value_changed.connect(_on_h_slider_m_1_value_changed)
	
	update_cable()

func create_grid():
	# Tworzenie siatki dostosowanej do wymiarów ekranu
	var grid_points = PackedVector2Array()
	var grid_size = 50  # odstęp między liniami
	var width = 1153    # szerokość ekranu
	var height = 500    # wysokość ekranu
	
	# Linie pionowe
	for x in range(0, width + 1, grid_size):
		grid_points.append(Vector2(x, 0))
		grid_points.append(Vector2(x, height))
		grid_points.append(Vector2(0, 0))  # przerwa między liniami
	
	# Linie poziome
	for y in range(0, height + 1, grid_size):
		grid_points.append(Vector2(0, y))
		grid_points.append(Vector2(width, y))
		grid_points.append(Vector2(0, 0))  # przerwa między liniami
	
	# Jeśli nie ma węzła Grid w scenie, utwórz go dynamicznie
	if not grid:
		grid = Line2D.new()
		add_child(grid)
		grid.z_index = -1  # Ustaw za wykresem
	
	grid.points = grid_points
	grid.width = 1
	grid.default_color = Color.GRAY

func _on_h_slider_m_0_value_changed(value: float):
	print("M0 changed to: ", value)
	m0 = Vector2(0, value)
	update_cable()

func _on_h_slider_m_1_value_changed(value: float):
	print("M1 changed to: ", value)
	m1 = Vector2(0, value)
	update_cable()

func update_cable():
	var points = hermite_curve(p0, m0, p1, m1, 100)  # Zwiększona rozdzielczość
	cable.points = points

func hermite_curve(p0: Vector2, m0: Vector2, p1: Vector2, m1: Vector2, resolution: int) -> PackedVector2Array:
	var pts = PackedVector2Array()
	for i in range(resolution + 1):
		var t = float(i) / resolution
		pts.append(hermite(p0, m0, p1, m1, t))
	return pts

func hermite(p0: Vector2, m0: Vector2, p1: Vector2, m1: Vector2, t: float) -> Vector2:
	var t2 = t * t
	var t3 = t2 * t
	var h00 = 2*t3 - 3*t2 + 1
	var h10 = t3 - 2*t2 + t
	var h01 = -2*t3 + 3*t2
	var h11 = t3 - t2
	return h00 * p0 + h10 * m0 + h01 * p1 + h11 * m1
