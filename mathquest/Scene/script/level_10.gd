extends Node3D

const END_GAME = "res://UI/KoniecPoziomu/KoniecGry.tscn"

var is_open := false
@onready var animation_player: AnimationPlayer = $"Word/Tunnel/Enter/wejscie/door-sliding-double2/AnimationPlayer"
@onready var ekran_3d: Node3D = $Komputer/Ekran_3d
@onready var alarm: OmniLight3D = $Alarm
@onready var wyjscie: Node3D = $"Koniec gry/double-door"
@onready var komputer: QuizManager = $Komputer

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level = 10
	trigger_bsod()
	komputer.connect("computers_completed", Callable(self, "_on_all_tasks_finished"))

		
func trigger_bsod():
	if ekran_3d and ekran_3d.has_method("show_bsod"):
		ekran_3d.show_bsod()

func _on_all_tasks_finished():
	wyjscie.open_door()
	alarm.visible = false
	alarm.light_energy = 0.0


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(END_GAME)
		get_tree().change_scene_to_packed(new_scene)
