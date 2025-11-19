extends Control

@onready var settings: Control = $"."
@onready var window: OptionButton = $VBoxContainer/GridContainer/Window
@onready var volume_slider: HSlider = $VBoxContainer/GridContainer/VolumeSlider

func _ready() -> void:
	window.add_theme_font_size_override("font_size", 40)
	
	load_settings()
	
	if volume_slider:
		volume_slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		volume_slider.min_value = 0
		volume_slider.max_value = 100
		volume_slider.step = 5
		volume_slider.ticks_on_borders = true

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", volume_slider.value)
	var window_mode = window.selected
	config.set_value("video", "window_mode", window_mode)
	config.save("user://settings.cfg")

func load_settings():
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	
	if err == OK:
		var saved_volume = config.get_value("audio", "music_volume", 50.0)
		volume_slider.value = saved_volume
		MusicManager.set_music_volume(saved_volume)
		
		var saved_window_mode = config.get_value("video", "window_mode", 0)
		window.select(saved_window_mode)
		apply_window_mode(saved_window_mode)

func apply_window_mode(index: int):
	match index:
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1:  
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:  
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func _on_window_item_selected(index: int) -> void:
	apply_window_mode(index)
	save_settings()

func _on_exti_settings_pressed() -> void:
	save_settings()
	settings.visible = false

func _on_volume_slider_value_changed(value: float) -> void:
	MusicManager.set_music_volume(value)
	save_settings()
