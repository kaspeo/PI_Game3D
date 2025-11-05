extends CollisionObject3D
class_name Interactable

@export var icon_label: Label3D
var is_solved := false
var has_question := false  # Nowa zmienna - czy komputer ma pytanie

@onready var level_21: Control = $"../Level_21"
@onready var level_22: Control = $"../../MisjaKod2/Level_22"
@onready var level_3: Control = $"../Level3Wykres"
@onready var level_41: Control = $"../Level4_1"
@onready var level_42: Control = $"../../MisjaLevel4_2/Level4_2"
@onready var level_51: Control = $"../Level51"
@onready var level_52: Control = $"../../Drzwi2/Level52"
@onready var level_53: Control = $"../../Drzwi3/Level53"
@onready var level_61: Control = $"../Level61"
@onready var level_62: Control = $"../../Drzwi2/Level62"
@onready var level_63: Control = $"../../Drzwi3/Level63"
@onready var level_64: Control = $"../../Drzwi4/Level64"
@onready var level_7_kod: Control = $"../Level7_kod"
@onready var level_7_dane: Control = $"../../MisjaDane/Level7Dane"
@onready var level_10_quiz: Control = $"../Level_10_quiz"

@export var quiz_manager_path: NodePath

var current_level = Global.current_level

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_input = "interact"

func _ready():
	# Ukryj ikonę na początku, będzie pokazana tylko gdy ma pytanie
	if icon_label:
		icon_label.visible = false

func get_prompt():
	# Dla komputerów Level_10 pokazuj prompt tylko jeśli mają pytanie i nie są rozwiązane
	if name.begins_with("Level_10_"):
		if not has_question or is_solved:
			return ""  # Brak prompta dla komputerów bez pytań lub rozwiązanych
	
	if prompt_input == null or prompt_input == "":
		return prompt_message

	var key_name = ""
	for action in InputMap.action_get_events(prompt_input):
		if action is InputEventKey:
			key_name = action.as_text_physical_keycode()
			break
	
	if key_name == "":
		return prompt_message
		
	return prompt_message + "\n[" + key_name + "]"

func interact(body):
	# Sprawdź czy komputer ma pytanie i nie jest rozwiązany
	if name.begins_with("Level_10_") and (not has_question or is_solved):
		return  # Nie interaktywne jeśli nie ma pytania lub już rozwiązane
	
	if name == "Level_2_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_21.visible = true
	
	elif name == "Level_2_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_22.visible = true
		
	elif name == "Level_3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_3.visible = true
		
	elif name == "Level_4_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_41.visible = true
	
	elif name == "Level_4_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_42.visible = true
		
	elif name == "Level_5_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_51.visible = true
		
	elif name == "Level_5_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_52.visible = true
		
	elif name == "Level_5_3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_53.visible = true
		
	elif name == "Level_6_1":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_61.visible = true
	
	elif name == "Level_6_2":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_62.visible = true
		
	elif name == "Level_6_3":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_63.visible = true
		
	elif name == "Level_6_4":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_64.visible = true	
		
	elif name == "Level_7_kod":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_7_kod.visible = true	
		
	elif name == "Level_7_dane":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false
		level_7_dane.visible = true	
		
	elif name.begins_with("Level_10_"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Global.can_move = false

		var quiz_manager = get_node_or_null(quiz_manager_path)
		if quiz_manager:
			quiz_manager.show_question_for_computer(get_path())
		else:
			push_warning("Nie znaleziono QuizManagera pod ścieżką: " + str(quiz_manager_path))

	else:
		emit_signal("interacted", body)

func _update_icon():
	if not icon_label:
		return
		
	if not has_question:
		# Komputer bez pytania - ukryj ikonę całkowicie
		icon_label.visible = false
	else:
		icon_label.visible = true
		if is_solved:
			# Rozwiązany - zielony znaczek
			icon_label.text = "✔"
			icon_label.modulate = Color(0, 1, 0)
		else:
			# Ma pytanie, nie rozwiązany - czerwony X
			icon_label.text = "✖"
			icon_label.modulate = Color(1, 0, 0)

# Ustaw komputer jako mający pytanie
func set_question_assigned():
	is_solved = false
	has_question = true
	_update_icon()

# Ustaw komputer jako rozwiązany
func mark_solved():
	is_solved = true
	has_question = false  # Po rozwiązaniu już nie ma pytania
	_update_icon()

# Ustaw komputer jako nie mający pytania (nieinteraktywny)
func set_no_question():
	has_question = false
	is_solved = false
	_update_icon()
