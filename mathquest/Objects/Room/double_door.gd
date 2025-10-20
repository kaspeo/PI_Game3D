extends Node3D

var playback : AnimationNodeStateMachinePlayback
var is_open := false

@onready var crate_1: RigidBody3D = $"../Skrzynki/Crate1"
@onready var crate_2: RigidBody3D = $"../Skrzynki/Crate2"
@onready var crate_3: RigidBody3D = $"../Skrzynki/Crate3"
@onready var crate_4: RigidBody3D = $"../Skrzynki/Crate4"
@onready var crate_5: RigidBody3D = $"../Skrzynki/Crate5"

@onready var area_1: Area3D = $"../Cele/Area1"
@onready var area_2: Area3D = $"../Cele/Area2"
@onready var area_3: Area3D = $"../Cele/Area3"
@onready var area_4: Area3D = $"../Cele/Area4"
@onready var area_5: Area3D = $"../Cele/Area5"

var correct_crates := {}

var placed := {}

func _ready() -> void:
	playback = $"door-sliding-double2/AnimationTree".get("parameters/playback")

	correct_crates = {
		area_1: crate_1,
		area_2: crate_2,
		area_3: crate_3,
		area_4: crate_4,
		area_5: crate_5
	}
	for area in correct_crates:
		placed[area] = false
		area.body_entered.connect(_on_area_body_entered.bind(area))
		area.body_exited.connect(_on_area_body_exited.bind(area))


func _check_all_placed() -> void:
	for area in placed:
		if not placed[area]:
			return
	_open_door()
	if Global.get_ui():
			Global.get_ui().ustaw_misje("Przenieś skrzynię", true)


func _open_door() -> void:
	if not is_open:
		is_open = true
		playback.travel("open")


func _on_area_body_entered(body: Node, area: Area3D) -> void:
	if body == correct_crates[area]:
		placed[area] = true
		print("✅ Skrzynka ", body.name, " poprawnie umieszczona w ", area.name)
		_check_all_placed()



func _on_area_body_exited(body: Node, area: Area3D) -> void:
	if body == correct_crates[area]:
		placed[area] = false
		if is_open:
			is_open = false
			playback.travel("close")
