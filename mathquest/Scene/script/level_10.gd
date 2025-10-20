extends Node3D

var is_open := false
@onready var animation_player: AnimationPlayer = $"Word/Tunnel/Enter/wejscie/door-sliding-double2/AnimationPlayer"


func open_door():
	if not is_open:
		is_open = true
		animation_player.play("open")

func _on_button_small_interacted(body: Variant) -> void:
	is_open = not is_open
	if is_open:
		animation_player.play("open")
	else:
		animation_player.play("close")
