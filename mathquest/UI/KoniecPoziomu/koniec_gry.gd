extends Control


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_do_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")
