extends Control

signal interpolation_solved

@onready var pseudocode_container: VBoxContainer = $MarginContainer/VBoxContainer/PseudocodeContainer
@onready var output_display: Label = $MarginContainer/VBoxContainer/OutputDisplay

@onready var f_0: Button = $MarginContainer/VBoxContainer/GridContainer/f0
@onready var __x_x_1_: Button = $"MarginContainer/VBoxContainer/GridContainer/(x-x1)"
@onready var __x_0_x_1_: Button = $"MarginContainer/VBoxContainer/GridContainer/(x0-x1)"
@onready var f_1: Button = $MarginContainer/VBoxContainer/GridContainer/f1
@onready var __x_x_0_: Button = $"MarginContainer/VBoxContainer/GridContainer/(x-x0)"
@onready var __x_1_x_0_: Button = $"MarginContainer/VBoxContainer/GridContainer/(x1-x0)"
@onready var fake_1: Button = $"MarginContainer/VBoxContainer/GridContainer/(x1-x)"
@onready var fake_2: Button = $"MarginContainer/VBoxContainer/GridContainer/(x0-x)"
@onready var fake_3: Button = $"MarginContainer/VBoxContainer/GridContainer/(x+x1)"

var drop_targets = {
	"f0_place": {"correct": "f₀", "filled": false, "node": null},
	"term1_num": {"correct": "(x-x₁)", "filled": false, "node": null},
	"term1_den": {"correct": "(x₀-x₁)", "filled": false, "node": null},
	"f1_place": {"correct": "f₁", "filled": false, "node": null},
	"term2_num": {"correct": "(x-x₀)", "filled": false, "node": null},
	"term2_den": {"correct": "(x₁-x₀)", "filled": false, "node": null}
}

var dragged_item: Button = null
var dragged_data_value: String = ""
var original_button_ref: Button = null

func _ready() -> void:
	_create_pseudocode_with_drop_zones()
	_setup_source_buttons()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and dragged_item:
		dragged_item.global_position = get_global_mouse_position() - dragged_item.size / 2
		_highlight_hovered_zone()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if dragged_item:
			_attempt_drop()
			dragged_item.queue_free()
			dragged_item = null
			original_button_ref = null
			_clear_highlights()

func _setup_source_buttons() -> void:
	var button_map = {
		f_0: "f₀",
		f_1: "f₁",
		__x_x_1_: "(x-x₁)",
		__x_0_x_1_: "(x₀-x₁)",
		__x_x_0_: "(x-x₀)",
		__x_1_x_0_: "(x₁-x₀)",
		fake_1: "(x₁-x)", 
		fake_2: "(x+x₁)",  
		fake_3: "(x₀-x)"
	}
	
	for btn in button_map.keys():
		if btn:
			btn.text = button_map[btn]
			btn.add_theme_color_override("font_color", Color.WHITE)
			var style = StyleBoxFlat.new()
			style.bg_color = Color(0.15, 0.5, 0.15, 1.0) 
			style.corner_radius_top_left = 4
			style.corner_radius_bottom_right = 4
			btn.add_theme_stylebox_override("normal", style)
			btn.button_down.connect(_on_source_button_down.bind(btn, button_map[btn]))
			

func _create_pseudocode_with_drop_zones() -> void:
	for child in pseudocode_container.get_children():
		child.queue_free()

	_create_label_header("INTERPOLACJA LAGRANGE (2 PUNKTY)")
	
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 20)
	pseudocode_container.add_child(spacer)

	var equation_row = HBoxContainer.new()
	equation_row.alignment = BoxContainer.ALIGNMENT_CENTER
	equation_row.add_theme_constant_override("separation", 15) 
	pseudocode_container.add_child(equation_row)

	_add_static_text(equation_row, "L(x)  = ", 24)

	_add_drop_zone_to(equation_row, "f0_place")
	
	_add_static_text(equation_row, " • ", 24)
	
	var fraction1 = VBoxContainer.new()
	fraction1.alignment = BoxContainer.ALIGNMENT_CENTER
	equation_row.add_child(fraction1)
	
	_add_drop_zone_to(fraction1, "term1_num")
	_add_fraction_line(fraction1)
	_add_drop_zone_to(fraction1, "term1_den")

	_add_static_text(equation_row, "   +   ", 32)

	_add_drop_zone_to(equation_row, "f1_place")
	
	_add_static_text(equation_row, " • ", 24)
	
	var fraction2 = VBoxContainer.new()
	fraction2.alignment = BoxContainer.ALIGNMENT_CENTER
	equation_row.add_child(fraction2)
	
	_add_drop_zone_to(fraction2, "term2_num")
	_add_fraction_line(fraction2)
	_add_drop_zone_to(fraction2, "term2_den")

func _create_label_header(text: String) -> void:
	var l = Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_size", 18)
	pseudocode_container.add_child(l)

func _add_drop_zone_to(parent: Control, zone_name: String) -> void:
	var zone = PanelContainer.new()
	zone.name = "DropZone_" + zone_name
	zone.custom_minimum_size = Vector2(130, 50) 
	
	var label = Label.new()
	label.text = "?"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_size", 20) 
	
	zone.add_theme_stylebox_override("panel", _create_zone_stylebox(false))
	zone.add_child(label)
	
	parent.add_child(zone)
	drop_targets[zone_name]["node"] = zone

func _add_static_text(parent: Control, text: String, size: int) -> void:
	var l = Label.new()
	l.text = text
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.add_theme_color_override("font_size", size)
	parent.add_child(l)

func _add_fraction_line(parent: Control) -> void:
	var line = HSeparator.new()
	line.custom_minimum_size = Vector2(120, 4) 
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(line)

func _on_source_button_down(btn: Button, val: String) -> void:
	original_button_ref = btn
	dragged_data_value = val
	
	dragged_item = Button.new()
	dragged_item.text = val
	dragged_item.size = btn.size
	dragged_item.custom_minimum_size = btn.custom_minimum_size
	dragged_item.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var style = btn.get_theme_stylebox("normal").duplicate()
	dragged_item.add_theme_stylebox_override("normal", style)
	
	add_child(dragged_item)
	dragged_item.global_position = get_global_mouse_position() - dragged_item.size / 2

func _highlight_hovered_zone() -> void:
	var mouse_pos = get_global_mouse_position()
	for zone_name in drop_targets:
		var data = drop_targets[zone_name]
		if data["filled"]: continue
		
		var node = data["node"] as Control
		if node.get_global_rect().has_point(mouse_pos):
			node.add_theme_stylebox_override("panel", _create_zone_stylebox(true))
		else:
			node.add_theme_stylebox_override("panel", _create_zone_stylebox(false))

func _clear_highlights() -> void:
	for zone_name in drop_targets:
		var data = drop_targets[zone_name]
		if not data["filled"] and data["node"]:
			data["node"].add_theme_stylebox_override("panel", _create_zone_stylebox(false))

func _attempt_drop() -> void:
	var mouse_pos = get_global_mouse_position()
	var dropped_successfully = false
	
	for zone_name in drop_targets:
		var data = drop_targets[zone_name]
		var node = data["node"] as Control
		
		if node.get_global_rect().has_point(mouse_pos) and not data["filled"]:
			if dragged_data_value == data["correct"]:
				_handle_correct_drop(zone_name, node)
				dropped_successfully = true
			else:
				output_display.text = "❌ Błąd: To nie jest " + dragged_data_value
				_flash_error(node, zone_name)
			break

func _flash_error(node: PanelContainer, zone_name: String) -> void:
	node.add_theme_stylebox_override("panel", _create_error_stylebox())
	await get_tree().create_timer(0.7).timeout
	if not drop_targets[zone_name]["filled"]:
		node.add_theme_stylebox_override("panel", _create_zone_stylebox(false))

func _handle_correct_drop(zone_name: String, zone_node: PanelContainer) -> void:
	drop_targets[zone_name]["filled"] = true
	
	var label = zone_node.get_child(0) as Label
	label.text = dragged_data_value
	label.add_theme_color_override("font_color", Color(0.2, 1.0, 0.2))
	label.add_theme_color_override("font_size", 20)
	zone_node.add_theme_stylebox_override("panel", _create_success_stylebox())
	
	if original_button_ref:
		original_button_ref.modulate.a = 0.0
		original_button_ref.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	output_display.text = "✓ Poprawnie: " + dragged_data_value
	_check_win_condition()

func _check_win_condition() -> void:
	var all_ok = true
	for key in drop_targets:
		if not drop_targets[key]["filled"]:
			all_ok = false
			break
	
	if all_ok:
		output_display.text = "BRAWO! Wzór Lagrange'a kompletny."
		emit_signal("interpolation_solved")

func _create_zone_stylebox(highlight: bool) -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.8, 0.8, 0.2, 0.5) if highlight else Color(0.16, 0.16, 0.4, 0.8)
	sb.border_color = Color(1, 1, 1, 0.5)
	sb.border_width_left = 2; sb.border_width_top = 2
	sb.border_width_right = 2; sb.border_width_bottom = 2
	sb.corner_radius_top_left = 6; sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_right = 6; sb.corner_radius_bottom_left = 6
	sb.content_margin_left = 8; sb.content_margin_right = 8
	return sb

func _create_success_stylebox() -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.1, 0.6, 0.1, 0.9)
	sb.border_width_left = 2; sb.border_width_top = 2
	sb.border_width_right = 2; sb.border_width_bottom = 2
	sb.corner_radius_top_left = 6; sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_right = 6; sb.corner_radius_bottom_left = 6
	return sb

func _create_error_stylebox() -> StyleBoxFlat:
	var sb = StyleBoxFlat.new()
	sb.bg_color = Color(0.8, 0.2, 0.2, 0.9)
	sb.border_color = Color(0.5, 0.1, 0.1, 1.0)
	sb.border_width_left = 2; sb.border_width_top = 2
	sb.border_width_right = 2; sb.border_width_bottom = 2
	sb.corner_radius_top_left = 6; sb.corner_radius_top_right = 6
	sb.corner_radius_bottom_right = 6; sb.corner_radius_bottom_left = 6
	return sb


func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	get_tree().paused = false
	visible = false
