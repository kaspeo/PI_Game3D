extends Control

class_name VolumeOfRevolutionComputer

var current_function: String = "x"
var integration_limits: Array = [0.0, 1.0]
var num_elements: int = 8

@onready var volume_graph: ColorRect = $VolumeGraph
@onready var result_label: Label = $ResultLabel
@onready var function_option: OptionButton = $FunctionOption
@onready var elements_slider: HSlider = $ElementsSlider
@onready var method_option: OptionButton = $MethodOption

func _ready():
	setup_ui()
	update_display()

func setup_ui():
	function_option.add_item("f(x) = x", 0)
	function_option.add_item("f(x) = x²", 1)
	function_option.add_item("f(x) = √x", 2)
	function_option.add_item("f(x) = sin(x)", 3)
	function_option.add_item("f(x) = 1", 4)
	
	method_option.add_item("Metoda dysków", 0)
	method_option.add_item("Metoda powłok", 1)
	method_option.add_item("Podgląd 3D", 2)
	
	elements_slider.min_value = 4
	elements_slider.max_value = 32
	elements_slider.value = 8

func _on_function_option_item_selected(index):
	var functions = ["x", "x*x", "sqrt(x)", "sin(x)", "1"]
	current_function = functions[index]
	update_display()

func _on_method_option_item_selected(index):
	var methods = ["disk", "shell", "3d_preview"]
	volume_graph.update_visualization(methods[index], num_elements)

func _on_elements_slider_value_changed(value):
	num_elements = int(value)
	update_display()

func update_display():
	volume_graph.set_problem(current_function, integration_limits)
	volume_graph.update_visualization("disk", num_elements)
	
	var volume_info = volume_graph.get_volume_info()
	var result_text = "Objętość bryły obrotowej:\n\n"
	result_text += "Metoda dysków: %.6f\n" % volume_info["disk_method"]
	result_text += "Metoda powłok: %.6f\n" % volume_info["shell_method"]
	result_text += "Wartość dokładna: %.6f" % volume_info["exact"]
	
	result_label.text = result_text
