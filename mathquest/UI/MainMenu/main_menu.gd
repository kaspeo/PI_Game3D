extends Control


func _ready() -> void:
	pass


func _on_start_game_pressed() -> void:
	Global.current_level = 0
	get_tree().change_scene_to_file("res://Scene/tutorial.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
