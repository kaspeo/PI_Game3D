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
