extends Control

@onready var player_ui: Control = get_node("../Player/UI")
@onready var exittutorial: PanelContainer = $PanelContainer2
@onready var task_label: Label = $TaskLabel
@onready var settings: Control = $Settings

func _ready() -> void:
	hide()
	settings.visible=false
	if Global.current_level != 0:
		exittutorial.hide()

func _on_resume_pressed() -> void:
	get_tree().paused = false  
	settings.visible=false
	
	if Global.can_move:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
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
		if Global.can_move:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player_ui.show()

func _on_exit_tutorial_pressed() -> void:
	Global.current_level=1
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_ustawienia_pressed() -> void:
	settings.visible=true
