extends Node3D

var is_open := false
@onready var animation_player: AnimationPlayer = $"Word/Tunnel/Enter/wejscie/door-sliding-double2/AnimationPlayer"
@onready var ekran_3d: Node3D = $Komputer/Ekran_3d

func _ready() -> void:
	trigger_bsod()
	
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
		
func trigger_bsod():
	if ekran_3d and ekran_3d.has_method("show_bsod"):
		ekran_3d.show_bsod()
