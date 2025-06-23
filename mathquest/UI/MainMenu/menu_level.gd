extends Control

	
func _on_level_1_pressed() -> void:
	Global.current_level = 1
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_level_2_pressed() -> void:
	Global.current_level = 2
	get_tree().change_scene_to_file("res://Scene/level_2.tscn")

func _on_level_3_pressed() -> void:
	Global.current_level = 3
	
func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")
