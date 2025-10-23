extends Control

@onready var misja: Label = $PaneMisji/HBoxContainer/Misja
@onready var status_m: Label = $PaneMisji/HBoxContainer/StatusM
@onready var label: Label = $Label

func _ready() -> void:
	await get_tree().process_frame
	Global.set_ui(self)
	update_level_label()

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
