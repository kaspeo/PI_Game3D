extends Node3D

@onready var arrowmov: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	arrowmov.play("MoveUpDown") 
