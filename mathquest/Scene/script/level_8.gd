extends Node3D

var playback : AnimationNodeStateMachinePlayback
var is_open := false
var popup_shown := false
const LEVEL_9 = "res://Scene/Level_9.tscn"
@onready var misja: AcceptDialog = $Dialogi/Misja

@onready var box_large_1: RigidBody3D = $Ekrany/Ekran1/BoxLarge_1
@onready var box_long_1: RigidBody3D = $Ekrany/Ekran1/BoxLong_1
@onready var box_small_1: RigidBody3D = $Ekrany/Ekran1/BoxSmall_1

@onready var box_large_2: RigidBody3D = $Ekrany/Ekran2/BoxLarge_2
@onready var box_long_2: RigidBody3D = $Ekrany/Ekran2/BoxLong_2
@onready var box_small_2: RigidBody3D = $Ekrany/Ekran2/BoxSmall_2

@onready var ekran_1: Node3D = $Ekrany/Ekran1/Ekran_8_1
@onready var ekran_2: Node3D = $Ekrany/Ekran2/Ekran_8_2

@onready var area_ekran_1: Area3D = $Ekrany/Ekran1/AreaEkran1
@onready var area_ekran_2: Area3D = $Ekrany/Ekran2/AreaEkran2

@onready var wyjscie: Node3D = $Wyjscie/Enter/door

var placed_boxes_1 = []
var placed_boxes_2 = []

func _ready() -> void:
	MusicManager.play_music("res://Sounds/Music/ingame.wav")
	Global.current_level=8
	area_ekran_1.body_entered.connect(_on_area_1_body_entered)
	area_ekran_2.body_entered.connect(_on_area_2_body_entered)
	area_ekran_1.body_exited.connect(_on_area_1_body_exited)
	area_ekran_2.body_exited.connect(_on_area_2_body_exited)
	
	if ekran_1.has_method("show_empty"):
		ekran_1.show_empty()
	if ekran_2.has_method("show_empty"):
		ekran_2.show_empty()

func _on_area_1_body_entered(body: Node) -> void:
	if body is RigidBody3D and (body == box_large_1 or body == box_long_1 or body == box_small_1):
		if not placed_boxes_1.has(body):
			placed_boxes_1.append(body)
			update_screen_1_display()
			_check_all_placed()

func _on_area_1_body_exited(body: Node) -> void:
	if body is RigidBody3D and (body == box_large_1 or body == box_long_1 or body == box_small_1):
		if placed_boxes_1.has(body):
			placed_boxes_1.erase(body)
			update_screen_1_display()
			_check_all_placed()

func _on_area_2_body_entered(body: Node) -> void:
	if body is RigidBody3D and (body == box_large_2 or body == box_long_2 or body == box_small_2):
		if not placed_boxes_2.has(body):
			placed_boxes_2.append(body)
			update_screen_2_display()
			_check_all_placed()

func _on_area_2_body_exited(body: Node) -> void:
	if body is RigidBody3D and (body == box_large_2 or body == box_long_2 or body == box_small_2):
		if placed_boxes_2.has(body):
			placed_boxes_2.erase(body)
			update_screen_2_display()
			_check_all_placed()

func update_screen_1_display() -> void:
	if placed_boxes_1.size() > 3:
		if ekran_1.has_method("show_too_many_boxes"):
			ekran_1.show_too_many_boxes()
		return
	
	var all_correct = (placed_boxes_1.has(box_large_1) and 
					  placed_boxes_1.has(box_long_1) and 
					  placed_boxes_1.has(box_small_1))
	
	if ekran_1.has_method("show_empty") and ekran_1.has_method("show_correct_solution") and ekran_1.has_method("show_incorrect_solution"):
		if placed_boxes_1.is_empty():
			ekran_1.show_empty()
		elif all_correct and placed_boxes_1.size() == 3:
			ekran_1.show_correct_solution()
		else:
			ekran_1.show_incorrect_solution()

func update_screen_2_display() -> void:
	if placed_boxes_2.size() > 3:
		if ekran_2.has_method("show_too_many_boxes"):
			ekran_2.show_too_many_boxes()
		return
	
	var all_correct = (placed_boxes_2.has(box_large_2) and 
					  placed_boxes_2.has(box_long_2) and 
					  placed_boxes_2.has(box_small_2))
	
	if ekran_2.has_method("show_empty") and ekran_2.has_method("show_correct_solution") and ekran_2.has_method("show_incorrect_solution"):
		if placed_boxes_2.is_empty():
			ekran_2.show_empty()
		elif all_correct and placed_boxes_2.size() == 3:
			ekran_2.show_correct_solution()
		else:
			ekran_2.show_incorrect_solution()

func _check_all_placed() -> void:
	var all_correct_1 = (placed_boxes_1.has(box_large_1) and 
						placed_boxes_1.has(box_long_1) and 
						placed_boxes_1.has(box_small_1))
	
	var all_correct_2 = (placed_boxes_2.has(box_large_2) and 
						placed_boxes_2.has(box_long_2) and 
						placed_boxes_2.has(box_small_2))
	
	if all_correct_1 and all_correct_2 and placed_boxes_1.size() == 3 and placed_boxes_2.size() == 3:
		_open_door()
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Wszystkie pudełka ułożono poprawnie!", true)

func _open_door() -> void:
	if not is_open:
		is_open = true
		wyjscie.open_door()

		
func show_misja_dialog() -> void:
	misja.popup_centered()
	misja.grab_focus()
	misja.connect("confirmed", Callable(self, "_on_misja_confirmed"))

func _on_misja_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Wstaw pudełka do odpowiednich miejsc", false)
		if not popup_shown:
			popup_shown = true
			show_misja_dialog()


func _on_zmiana_poziomu_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		var new_scene = load(LEVEL_9)
		get_tree().change_scene_to_packed(new_scene)
