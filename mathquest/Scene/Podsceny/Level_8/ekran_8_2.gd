extends Node3D

@onready var viewport: SubViewport = $SubViewport
@onready var hermite_ui: Control = $SubViewport/Wykres82

func _ready():
	viewport.size = Vector2i(512, 512)
	viewport.disable_3d = true                
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	viewport.gui_disable_input = false
	await get_tree().process_frame
	
	show_empty()

func show_empty():
	if hermite_ui and hermite_ui.has_method("show_empty"):
		hermite_ui.show_empty()

func show_correct_solution():
	if hermite_ui and hermite_ui.has_method("show_correct_solution"):
		hermite_ui.show_correct_solution()

func show_incorrect_solution():
	if hermite_ui and hermite_ui.has_method("show_incorrect_solution"):
		hermite_ui.show_incorrect_solution()
