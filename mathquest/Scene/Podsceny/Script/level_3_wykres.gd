extends Control

@onready var graph: Control = $PanelContainer/GraphDrawer
@onready var point_sliders := []

func _ready():
	
	var slider_container = $PanelContainer2/VBoxContainer
	for child in slider_container.get_children():
		child.queue_free()
	
	point_sliders.clear()
	
	for i in range(graph.point_count):
		var vbox = VBoxContainer.new()
		slider_container.add_child(vbox)
		
		var label = Label.new()
		label.text = "Punkt %d (x=%.1f)" % [i, graph.points[i]["x"]]
		vbox.add_child(label)
		
		var slider = HSlider.new()
		slider.min_value = graph.y_min
		slider.max_value = graph.y_max
		slider.value = graph.points[i]["y"]
		slider.step = 0.1
		slider.connect("value_changed", Callable(self, "_on_slider_value_changed").bind(i))
		vbox.add_child(slider)
		
		var value_label = Label.new()
		value_label.name = "ValueLabel"
		value_label.text = "y = %.1f" % slider.value
		vbox.add_child(value_label)
		
		point_sliders.append({"slider": slider, "label": value_label})

func _on_slider_value_changed(value: float, index: int):
	graph.set_point_value(index, value)
	point_sliders[index]["label"].text = "y = %.1f" % value

func _on_exit_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.can_move = true
	get_tree().paused = false
	visible = false
