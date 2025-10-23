extends Control

@onready var result_label: Label = $HBoxContainer3/ResultLabel
@onready var label_2: TextEdit = $HBoxContainer/GridContainer2/Label2
@onready var label_3: TextEdit = $HBoxContainer/GridContainer2/Label3
@onready var label_16: TextEdit = $HBoxContainer/GridContainer2/Label16
@onready var drzwi3: Node3D = $"../drzwi3"


func _on_sprawdź_pressed() -> void:
	var ok = true

	if label_2.text.strip_edges() != "0":
		ok = false
	if label_3.text.strip_edges() != "0":
		ok = false
	if label_16.text.strip_edges() != "37/2":
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
