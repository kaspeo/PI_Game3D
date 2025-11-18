extends Control

@onready var player_ui: Control = get_node("../Player/UI")
@onready var exittutorial: PanelContainer = $PanelContainer2
@onready var task_label: Label = $TaskLabel
@onready var settings: Panel = $Settings
@onready var window: OptionButton = $Settings/VBoxContainer/Window

func _ready() -> void:
	window.add_theme_font_size_override("font_size", 40)
	hide()
	settings.visible=false
	if Global.current_level != 0:
		exittutorial.hide()

func _on_resume_pressed() -> void:
	get_tree().paused = false  
	settings.visible=false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	hide()
	player_ui.show()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	settings.visible=false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	visible = get_tree().paused

	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player_ui.hide()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player_ui.show()


func _on_exit_tutorial_pressed() -> void:
	Global.current_level=1
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")


func _on_ustawienia_pressed() -> void:
	settings.visible=true

func _on_window_item_selected(index: int) -> void:
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


func _on_exti_settings_pressed() -> void:
	settings.visible=false
