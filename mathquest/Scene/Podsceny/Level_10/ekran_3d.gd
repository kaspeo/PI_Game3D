extends Node3D

@onready var viewport: SubViewport = $SubViewport
@onready var bsod_ui: Control = $SubViewport/Level_10_ekran

var total_questions := 10
var completed_questions := 0
var is_active := false

func _ready():
	viewport.size = Vector2i(512, 512)
	viewport.disable_3d = true                
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	viewport.gui_disable_input = false
	await get_tree().process_frame

func show_bsod():
	visible = true
	is_active = true
	
	if bsod_ui and bsod_ui.has_method("show_bsod"):
		bsod_ui.show_bsod()
	
	_update_display()

func question_completed():
	if not is_active:
		return
		
	completed_questions += 1
	_update_display()


func _update_display():
	if bsod_ui and bsod_ui.has_method("update_progress"):
		bsod_ui.update_progress(completed_questions, total_questions)
