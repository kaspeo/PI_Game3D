extends Control

@onready var misja: Label = $PaneMisji/HBoxContainer/Misja
@onready var status_m: Label = $PaneMisji/HBoxContainer/StatusM

func _ready() -> void:
	Global.set_ui(self)

func ustaw_misje(nazwa: String, ukonczona: bool) -> void:
	misja.text = nazwa
	if ukonczona:
		status_m.text = "✅ Ukończona"
		status_m.add_theme_color_override("font_color", Color.GREEN)
	else:
		status_m.text = "❌ Nieukończona"
		status_m.add_theme_color_override("font_color", Color.RED)
