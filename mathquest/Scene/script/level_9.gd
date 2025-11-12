extends Node3D

const LEVEL_10 = "res://Scene/Level_10.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.current_level==9

func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_10)
		get_tree().change_scene_to_packed(new_scene)
