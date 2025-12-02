extends Control

@onready var label_6: TextEdit = $MarginContainer/HBoxContainer/GridContainer2/Label6
@onready var label_7: TextEdit = $MarginContainer/HBoxContainer/GridContainer2/Label7
@onready var label_8: TextEdit = $MarginContainer/HBoxContainer/GridContainer2/Label8
@onready var label_18: TextEdit = $MarginContainer/HBoxContainer/GridContainer2/Label18
@onready var result_label: Label = $MarginContainer/HBoxContainer3/ResultLabel
@onready var drzwi1: Node3D = $"../drzwi1"


func _on_sprawdź_pressed() -> void:
	var ok = true

	if label_6.text.strip_edges() != "0":
		ok = false
	if label_7.text.strip_edges() != "-1":
		ok = false
	if label_8.text.strip_edges() != "1":
		ok = false
	if label_18.text.strip_edges() != "1":
		ok = false

	if ok:
		result_label.text = "✅ Poprawnie!"
		Global.get_ui().ustaw_misje("Macierz zadanie", true)
		drzwi1.open_door()
	else:
		result_label.text = "❌ Coś się nie zgadza, spróbuj ponownie."



func _on_wyjdz_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible = false
