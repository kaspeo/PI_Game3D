extends Node3D

const END_GAME = "res://UI/KoniecPoziomu/KoniecGry.tscn"

var popup_shown := false
var is_open := false
@onready var animation_player: AnimationPlayer = $"Word/Tunnel/Enter/wejscie/door-sliding-double2/AnimationPlayer"
@onready var ekran_3d: Node3D = $Komputer/Ekran_3d
@onready var alarm: OmniLight3D = $Alarm
@onready var wyjscie: Node3D = $"Koniec gry/double-door"
@onready var komputer: QuizManager = $Komputer
@onready var misja: AcceptDialog = $Dialogi/Misja

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
	if Global.get_ui():
				Global.get_ui().ustaw_misje("Naprawiono wszystkie komputery", false)


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		Progess.complete_level(10)
		var new_scene = load(END_GAME)
		get_tree().change_scene_to_packed(new_scene)


func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if not popup_shown:
			popup_shown = true
			misja.visible = true
			if Global.get_ui():
				Global.get_ui().ustaw_misje("Rozwiąż zadania na 12 komputerach", false)
