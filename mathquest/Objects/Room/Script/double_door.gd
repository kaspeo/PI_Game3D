extends Node3D

var playback : AnimationNodeStateMachinePlayback
var is_open := false

func _ready() -> void:
	playback = $"door-sliding-double2/AnimationTree".get("parameters/playback")
	
func toggle(_body):
	is_open = not is_open
	if is_open:
		playback.travel("open")
	else:
		playback.travel("close")	


func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name == "Skrzynka":
		playback.travel("open")
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Przenieś skrzynię", true)
