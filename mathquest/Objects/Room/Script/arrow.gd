extends Node3D

@onready var arrowmov: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrowmov.play("MoveUpDown") 
