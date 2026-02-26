extends Control

@onready var settings: Control = $Settings
@onready var autors: Control = $AutorsMenu
@onready var game_version: Label = $GameVersion

func _ready() -> void:
	game_version.text = "Version " + str(Global.game_version)
	MusicManager.play_music("res://Sounds/Music/menu.wav")
	settings.visible=false
	pass


func _on_start_game_pressed() -> void:
	Global.current_level = 0
	get_tree().change_scene_to_file("res://Scene/tutorial.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_select_level_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu/MenuLevel.tscn")


func _on_settings_pressed() -> void:
	settings.visible=true


func _on_autor_pressed() -> void:
	autors.visible=true
