extends Control

	
func _on_level_1_pressed() -> void:
	Global.current_level = 1
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_level_2_pressed() -> void:
	Global.current_level = 2
	get_tree().change_scene_to_file("res://Scene/level_2.tscn")

func _on_level_3_pressed() -> void:
	Global.current_level = 3
	get_tree().change_scene_to_file("res://Scene/level_3.tscn")

func _on_level_4_pressed() -> void:
	Global.current_level = 4
	get_tree().change_scene_to_file("res://Scene/level_4.tscn")

func _on_level_5_pressed() -> void:
	Global.current_level = 5
	get_tree().change_scene_to_file("res://Scene/level_5.tscn")
	
func _on_level_6_pressed() -> void:
	Global.current_level = 6
	get_tree().change_scene_to_file("res://Scene/level_6.tscn")


func _on_level_7_pressed() -> void:
	Global.current_level = 7
	get_tree().change_scene_to_file("res://Scene/level_7.tscn")


func _on_level_8_pressed() -> void:
	Global.current_level = 8
	get_tree().change_scene_to_file("res://Scene/level_8.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")
