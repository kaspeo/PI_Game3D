extends Control

@onready var player_ui: Control = get_node("../Player/UI")
@onready var exittutorial: PanelContainer = $PanelContainer2
@onready var task_label: Label = $TaskLabel
@onready var settings: Control = $Settings
@onready var notes_dialog: AcceptDialog = $AcceptDialog
@onready var confirmation_exit: ConfirmationDialog = $ConfirmationExit

var simple_notes = {}

func _ready() -> void:
	hide()
	confirmation_exit.visible= false
	settings.visible = false
	load_simple_notes()
	notes_dialog.visible=false
	if Global.current_level != 0:
		exittutorial.hide()

func _on_resume_pressed() -> void:
	get_tree().paused = false  
	settings.visible = false
	
	if Global.can_move:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	hide()
	player_ui.show()

func _on_exit_pressed() -> void:
	confirmation_exit.popup_centered()
	

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
	Global.current_level = 1
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_ustawienia_pressed() -> void:
	settings.visible = true

func _on_podpowiedz_pressed() -> void:
	if notes_dialog.visible:
		notes_dialog.hide()
	else:
		show_note()

func show_note():
	var current_level = Global.current_level
	var level_key = str(current_level)
	
	if simple_notes.has(level_key):
		notes_dialog.dialog_text = simple_notes[level_key]
	else:
		notes_dialog.dialog_text = "Brak notatki dla tego poziomu."
	
	notes_dialog.popup_centered(Vector2(500, 400))


func load_simple_notes():
	var file = FileAccess.open("res://Notatki/notes.json", FileAccess.READ)
	if file:
		var json = JSON.new()
		var error = json.parse(file.get_as_text())
		if error == OK:
			simple_notes = json.data
		else:
			print("JSON parse error: ", json.get_error_message())
		file.close()
	else:
		print("Could not open notes.json")


func _on_confirmation_dialog_confirmed() -> void:
	get_tree().paused = false
	settings.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")
