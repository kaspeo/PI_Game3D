extends Node3D

var playback : AnimationNodeStateMachinePlayback
var is_open := false
var popup_shown := false

@onready var misja: AcceptDialog = $Dialogi/Misja

@onready var box_large_1: RigidBody3D = $Ekrany/Ekran1/BoxLarge_1
@onready var box_long_1: RigidBody3D = $Ekrany/Ekran1/BoxLong_1
@onready var box_small_1: RigidBody3D = $Ekrany/Ekran1/BoxSmall_1

@onready var ekran_1: Node3D = $Ekrany/Ekran1/Ekran_8_1

@onready var area_ekran_1: Area3D = $Ekrany/Ekran1/AreaEkran1

@onready var wyjscie: Node3D = $Wyjscie/Enter/door

var placed_boxes = []

func _ready() -> void:

	area_ekran_1.body_entered.connect(_on_area_body_entered)
	
	if ekran_1.has_method("show_empty"):
		ekran_1.show_empty()

func _on_area_body_entered(body: Node) -> void:
	if body is RigidBody3D and (body == box_large_1 or body == box_long_1 or body == box_small_1):
		if not placed_boxes.has(body):
			placed_boxes.append(body)
			update_screen_display()
			_check_all_placed()


func update_screen_display() -> void:
	var all_correct = (placed_boxes.has(box_large_1) and 
					  placed_boxes.has(box_long_1) and 
					  placed_boxes.has(box_small_1))
	
	if ekran_1.has_method("show_empty") and ekran_1.has_method("show_correct_solution") and ekran_1.has_method("show_incorrect_solution"):
		if placed_boxes.is_empty():
			ekran_1.show_empty()
		elif all_correct and placed_boxes.size() == 3:
			ekran_1.show_correct_solution()
		else:
			ekran_1.show_incorrect_solution()

func _check_all_placed() -> void:
	var all_correct = (placed_boxes.has(box_large_1) and 
					  placed_boxes.has(box_long_1) and 
					  placed_boxes.has(box_small_1))
	
	if all_correct and placed_boxes.size() == 3:
		_open_door()
		if Global.get_ui():
			Global.get_ui().ustaw_misje("Funkcja rozwiązana poprawnie!", true)

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
