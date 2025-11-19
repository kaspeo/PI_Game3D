extends Control

@onready var misja: Label = $PaneMisji/HBoxContainer/Misja
@onready var status_m: Label = $PaneMisji/HBoxContainer/StatusM
@onready var label: Label = $Label
@onready var poziom_info: Label = $MarginContainer/Level
@onready var timer: Timer = $Timer

func _ready() -> void:
	await get_tree().process_frame
	Global.set_ui(self)
	update_level_label()
	show_level_info()

func update_level_label() -> void:
	if Global.current_level == 0:
		label.text = "Tutorial"
	else:
		label.text = "Poziom: %d" % Global.current_level

func ustaw_misje(nazwa: String, ukonczona: bool) -> void:
	misja.text = nazwa
	if ukonczona:
		status_m.text = "✅ Ukończona"
		status_m.add_theme_color_override("font_color", Color.GREEN)
	else:
		status_m.text = "❌ Nieukończona"
		status_m.add_theme_color_override("font_color", Color.RED)

func show_level_info():
	var level_text = ""
	match Global.current_level:
		0:
			level_text = "Tutorial"
		1:
			level_text = "Poziom 1\nMetoda Bisekcji"
		2:
			level_text = "Poziom 2\nMetoda Regula Falsi"
		3:
			level_text = "Poziom 3\nMetoda Siecznych (Secanta)"
		4:
			level_text = "Poziom 4\nMetoda kolejnych przybliżeń\n i Newtona-Raphsona"
		5:
			level_text = "Poziom 5\nMetoda Gaussa"
		6:
			level_text = "Poziom 6\nMetoda Jordana"
		7:
			level_text = "Poziom 7\nMetoda Lagrange'a"
		8:
			level_text = "Poziom 8\nInterpolacja Hermita"
		9:
			level_text = "Poziom 9\nCałkowanie numeryczne"
		10:
			level_text = "Poziom 10\nCałkowanie numeryczne"
		11:
			level_text = "Poziom 11\nKońcowy quiz"
	
	poziom_info.text = level_text
	poziom_info.visible = true
	
	await get_tree().create_timer(3.0).timeout
	poziom_info.visible = false

func _on_timer_timeout():
	poziom_info.visible = false
