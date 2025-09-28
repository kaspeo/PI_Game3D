extends Control
@onready var text_edit: TextEdit = $HBoxContainer/GridContainer2/TextEdit
@onready var text_edit_2: TextEdit = $HBoxContainer/GridContainer2/TextEdit2
@onready var text_edit_3: TextEdit = $HBoxContainer/GridContainer2/TextEdit3

@onready var result_label: Label = $HBoxContainer3/ResultLabel
@onready var drzwi3: Node3D = $"../drzwi3"


func _on_sprawdź_pressed() -> void:
	var ok = true

	# Pobieranie i sprawdzanie wartości
	if text_edit.text.strip_edges() != "5/4":
		ok = false
	if text_edit_2.text.strip_edges() != "-1/4":
		ok = false
	if text_edit_3.text.strip_edges() != "3/4":
		ok = false
		
	if ok:
		result_label.text = "✅ Poprawnie!"
		Global.get_ui().ustaw_misje("Macierz zadanie", true)
		drzwi3.open_door()
	else:
		result_label.text = "❌ Coś się nie zgadza, spróbuj ponownie."



func _on_wyjdz_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	visible = false
