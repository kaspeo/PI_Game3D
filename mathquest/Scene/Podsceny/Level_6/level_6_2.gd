extends Control

@onready var result_label: Label = $HBoxContainer3/ResultLabel
@onready var label_8: TextEdit = $HBoxContainer/GridContainer2/Label8
@onready var label_18: TextEdit = $HBoxContainer/GridContainer2/Label18
@onready var drzwi2: Node3D = $"../Drzwi2"


func _on_sprawdź_pressed() -> void:
	var ok = true


	if label_8.text.strip_edges() != "0":
		ok = false
	if label_18.text.strip_edges() != "-11/2":
		ok = false

	if ok:
		result_label.text = "✅ Poprawnie!"
		Global.get_ui().ustaw_misje("Macierz zadanie", true)
		drzwi2.open_door()
	else:
		result_label.text = "❌ Coś się nie zgadza, spróbuj ponownie."



func _on_wyjdz_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible = false
