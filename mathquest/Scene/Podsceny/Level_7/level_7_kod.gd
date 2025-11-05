extends Control

@onready var level_lagrange: Control = $"."
@onready var code_edit: TextEdit = $HBoxContainer/CodeEdit
@onready var result_label: Label = $HBoxContainer/ResultLabel
@onready var exit_button: Button = $Exit

var correct_code := "L(x) = f0*(x - x1)/(x0 - x1) + f1*(x - x0)/(x1 - x0)"
var task_done := false

func _ready() -> void:
	code_edit.text = "# Wprowadź wzór interpolacji Lagrange'a dla 2 punktów\n# Dostępne zmienne: x0, x1, f0, f1, x"

func _on_exit_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.can_move = true
	get_tree().paused = false
	level_lagrange.visible = false

func _on_check_button_pressed() -> void:
	var entered_code = code_edit.text.strip_edges()
	
	# Usuń komentarze i białe znaki dla porównania
	var clean_entered = entered_code.replace("#", "").strip_edges().replace(" ", "")
	var clean_correct = correct_code.replace(" ", "")
	
	if clean_entered == clean_correct:
		result_label.text = "✅ Poprawnie! Wzór interpolacji Lagrange'a jest prawidłowy."
		result_label.add_theme_color_override("font_color", Color.GREEN)
		
		if not task_done:
			Global.get_ui().ustaw_misje("Interpolacja Lagrange'a", true)
			task_done = true
	else:
		result_label.text = "❌ Błąd we wzorze. Sprawdź czy używasz prawidłowych zmiennych."
		result_label.add_theme_color_override("font_color", Color.RED)

func _on_help_button_pressed() -> void:
	code_edit.text = correct_code
	result_label.text = "💡 Podpowiedź: Wzór został wstawiony. Przeanalizuj jego strukturę!"

func _on_clear_button_pressed() -> void:
	code_edit.text = ""
	result_label.text = "Wprowadź wzór interpolacji Lagrange'a..."

# Opcjonalnie: wersja z wieloma poprawnymi wariantami
var correct_variants := [
	"L(x) = f0*(x - x1)/(x0 - x1) + f1*(x - x0)/(x1 - x0)",
	"L(x)=f0*(x-x1)/(x0-x1)+f1*(x-x0)/(x1-x0)",
	"y = f0*(x - x1)/(x0 - x1) + f1*(x - x0)/(x1 - x0)",
	"P(x) = f0*(x - x1)/(x0 - x1) + f1*(x - x0)/(x1 - x0)"
]

func _on_check_button_pressed_v2() -> void:
	var entered_code = code_edit.text.strip_edges()
	var clean_entered = entered_code.replace("#", "").strip_edges().replace(" ", "")
	
	for variant in correct_variants:
		var clean_variant = variant.replace(" ", "")
		if clean_entered == clean_variant:
			result_label.text = "✅ Doskonale! Wzór interpolacji Lagrange'a jest poprawny."
			result_label.add_theme_color_override("font_color", Color.GREEN)
			
			if not task_done:
				Global.get_ui().ustaw_misje("Interpolacja Lagrange'a", true)
				task_done = true
			return
	
	result_label.text = "❌ Sprawdź wzór. Upewnij się, że:\n- używasz zmiennych x0, x1, f0, f1\n- prawidłowo grupujesz wyrażenia"
	result_label.add_theme_color_override("font_color", Color.RED)
