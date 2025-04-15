extends Interactable

func _on_interacted(_body: Variant) -> void:
	$AudioStreamPlayer3D.play()
