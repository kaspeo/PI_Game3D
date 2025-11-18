extends Node
class_name QuizManager

const COMPUTER_PREFIX := "Level_10_"
const TOTAL_COMPUTERS := 18
const QUESTIONS_TO_ASSIGN := 12
const QUESTIONS_FILE := "res://Scene/Podsceny/Level_10/questions.json"

var assignments = {} # ścieżka -> pytanie
var quiz_scene: Control
var questions = []
var bsod_display: Node3D
var total_questions_completed := 0

func _ready():
	randomize()
	_load_questions_from_file()
	_assign_questions_to_computers()
	quiz_scene = get_tree().get_root().find_child("Level_10_quiz", true, false)
	_find_bsod_display()

func _find_bsod_display():
	bsod_display = get_tree().get_root().find_child("Ekran_3d", true, false)
	if bsod_display:
		if bsod_display.has_method("set_total_questions"):
			bsod_display.set_total_questions(QUESTIONS_TO_ASSIGN)
		if bsod_display.has_method("show_bsod"):
			bsod_display.show_bsod()

func _load_questions_from_file():
	var file = FileAccess.open(QUESTIONS_FILE, FileAccess.READ)
	if file == null:
		return
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_text)
	if error == OK:
		questions = json.data

func _assign_questions_to_computers():
	if questions.size() == 0:
		return
		
	var computers = []
	for i in range(1, TOTAL_COMPUTERS + 1):
		var node = get_node_or_null("%s%d" % [COMPUTER_PREFIX, i])
		if node:
			computers.append(node)

	if computers.size() < QUESTIONS_TO_ASSIGN:
		return

	var chosen_computers = []
	while chosen_computers.size() < QUESTIONS_TO_ASSIGN:
		var idx = randi() % computers.size()
		if idx not in chosen_computers:
			chosen_computers.append(idx)

	for idx in chosen_computers:
		var comp = computers[idx]
		var q = questions[randi() % questions.size()]
		assignments[comp.get_path()] = q

		if comp.has_method("set_question_assigned"):
			comp.set_question_assigned()
			
	for i in range(computers.size()):
		var comp = computers[i]
		if i not in chosen_computers:
			if comp.has_method("set_no_question"):
				comp.set_no_question()

func show_question_for_computer(path: NodePath):
	var comp = get_node_or_null(path)
	if not comp:
		return

	var q = assignments.get(path)
	if not q:
		return

	if quiz_scene:
		quiz_scene.visible = true
		quiz_scene.set_question(q)
		if quiz_scene.answered.is_connected(_on_quiz_answered):
			quiz_scene.answered.disconnect(_on_quiz_answered)
		quiz_scene.answered.connect(_on_quiz_answered.bind(comp))

func _on_quiz_answered(correct: bool, comp: Node):
	if correct:
		comp.mark_solved()
		total_questions_completed += 1
		
		if bsod_display and bsod_display.has_method("question_completed"):
			bsod_display.question_completed()
	else:
		comp.set_question_assigned()
	
	if quiz_scene:
		quiz_scene.visible = false
	
	Global.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if total_questions_completed >= QUESTIONS_TO_ASSIGN:
		_all_questions_completed()

func _all_questions_completed():
	if bsod_display and bsod_display.has_method("hide_bsod"):
		var timer = get_tree().create_timer(3.0)
		timer.timeout.connect(bsod_display.hide_bsod)

func start_bsod():
	if bsod_display and bsod_display.has_method("show_bsod"):
		bsod_display.show_bsod()
		if bsod_display.has_method("set_total_questions"):
			bsod_display.set_total_questions(QUESTIONS_TO_ASSIGN)
