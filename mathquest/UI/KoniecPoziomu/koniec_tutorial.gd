extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_dalej_pressed() -> void:
	Global.current_level = 1
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")
