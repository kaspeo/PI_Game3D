extends Control

@onready var resume: Button = $PanelContainer/VBoxContainer/Resume
@onready var exit: Button = $PanelContainer/VBoxContainer/Exit

func _ready() -> void:
	resume.pressed.connect(_resume)
	exit.pressed.connect(_exit)
	hide() 

func _resume() -> void:
	get_tree().paused = false  
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	hide()

func _exit() -> void:
	get_tree().quit()  

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 
	visible = get_tree().paused
