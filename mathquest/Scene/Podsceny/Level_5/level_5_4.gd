extends Control
@onready var level_54: Control = $"."


@onready var result_label: Label = $HBoxContainer3/ResultLabel
@onready var drzwi4: Node3D = $"../drzwi4"
@onready var text_edit: LineEdit = $HBoxContainer/GridContainer2/TextEdit
@onready var text_edit_2: LineEdit = $HBoxContainer/GridContainer2/TextEdit2
@onready var text_edit_3: LineEdit = $HBoxContainer/GridContainer2/TextEdit3


func _on_sprawdź_pressed() -> void:
	var ok = true

	# Pobieranie i sprawdzanie wartości
	if text_edit.text.strip_edges() != "37/2":
		ok = false
	if text_edit_2.text.strip_edges() != "-11/2":
		ok = false
	if text_edit_3.text.strip_edges() != "7/2":
		ok = false
		
	if ok:
		result_label.text = "✅ Poprawnie!"
		Global.get_ui().ustaw_misje("Macierz zadanie", true)
		drzwi4.open_door()
	else:
		result_label.text = "❌ Coś się nie zgadza, spróbuj ponownie."



func _on_wyjdz_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	level_54.visible = false
