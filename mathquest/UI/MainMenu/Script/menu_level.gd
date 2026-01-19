extends Control

var unlocked_levels = 1

func _ready():
	if Progess:
		unlocked_levels = Progess.unlocked_levels
	
	_block_level_buttons()

func _block_level_buttons():
	unlocked_levels = 11
	if unlocked_levels < 2:
		$PanelContainer/VBoxContainer/HBoxContainer/Level2.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer/Level2.text = "🔒"
	if unlocked_levels < 3:
		$PanelContainer/VBoxContainer/HBoxContainer2/Level3.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer2/Level3.text = "🔒"
	if unlocked_levels < 4:
		$PanelContainer/VBoxContainer/HBoxContainer2/Level4.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer2/Level4.text = "🔒"
	if unlocked_levels < 5:
		$PanelContainer/VBoxContainer/HBoxContainer3/Level5.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer3/Level5.text = "🔒"
	if unlocked_levels < 6:
		$PanelContainer/VBoxContainer/HBoxContainer3/Level6.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer3/Level6.text = "🔒"
	if unlocked_levels < 7:
		$PanelContainer/VBoxContainer/HBoxContainer4/Level7.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer4/Level7.text = "🔒"
	if unlocked_levels < 8:
		$PanelContainer/VBoxContainer/HBoxContainer4/Level8.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer4/Level8.text = "🔒"
	if unlocked_levels < 9:
		$PanelContainer/VBoxContainer/HBoxContainer5/VBoxContainer/Level9.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer5/VBoxContainer/Level9.text = "🔒"
	if unlocked_levels < 10:
		$PanelContainer/VBoxContainer/HBoxContainer7/VBoxContainer/Level10.disabled = true
		$PanelContainer/VBoxContainer/HBoxContainer7/VBoxContainer/Level10.text = "🔒"

func _on_level_1_pressed() -> void:
	Global.current_level = 1
	Global.can_move = true
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_level_2_pressed() -> void:
	if unlocked_levels >= 2:
		Global.current_level = 2
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_2.tscn")

func _on_level_3_pressed() -> void:
	if unlocked_levels >= 3:
		Global.current_level = 3
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_3.tscn")

func _on_level_4_pressed() -> void:
	if unlocked_levels >= 4:
		Global.current_level = 4
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_4.tscn")

func _on_level_5_pressed() -> void:
	if unlocked_levels >= 5:
		Global.current_level = 5
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_5.tscn")
	
func _on_level_6_pressed() -> void:
	if unlocked_levels >= 6:
		Global.current_level = 6
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_6.tscn")

func _on_level_7_pressed() -> void:
	if unlocked_levels >= 7:
		Global.current_level = 7
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_7.tscn")

func _on_level_8_pressed() -> void:
	if unlocked_levels >= 8:
		Global.current_level = 8
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_8.tscn")

func _on_level_9_pressed() -> void:
	if unlocked_levels >= 9:
		Global.current_level = 9
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_9.tscn")

func _on_level_10_pressed() -> void:
	if unlocked_levels >= 10:
		Global.current_level = 10
		Global.can_move = true
		get_tree().change_scene_to_file("res://Scene/level_10.tscn")

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/MainMenu/MainMenu.tscn")
