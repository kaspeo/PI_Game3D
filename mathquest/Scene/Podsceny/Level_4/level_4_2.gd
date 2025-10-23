extends Control

# Zmienne gry
var current_guess = 2.0
var correct_solution = 2.0946
var tolerance = 0.01
var max_attempts = 10
var attempts = 0
var game_won = false
var score = 0

@onready var problem_label = $VBoxContainer/ProblemLabel
@onready var guess_label = $VBoxContainer/GuessLabel
@onready var attempts_label = $VBoxContainer/AttemptsLabel
@onready var result_label = $VBoxContainer/ResultLabel
@onready var score_label = $VBoxContainer/ScoreLabel
@onready var guess_input = $VBoxContainer/HBoxContainer/GuessInput
@onready var calculate_button = $VBoxContainer/HBoxContainer/CalculateButton
@onready var hint_button = $VBoxContainer/ButtonsContainer/HintButton
@onready var new_problem_button = $VBoxContainer/ButtonsContainer/NewProblemButton

func _ready():
	setup_problem()

func setup_problem():
	problem_label.text = "ZADANIE: Znajdź miejsce zerowe funkcji f(x) = x³ - 2x - 5"
	guess_label.text = "Aktualne przybliżenie: x = %.1f" % current_guess
	attempts_label.text = "Pozostało prób: %d" % (max_attempts - attempts)
	result_label.text = "Wprowadź swoje obliczenia następnego przybliżenia!"
	score_label.text = "Wynik: %d" % score
	game_won = false
	attempts = 0
	guess_input.text = ""
	calculate_button.disabled = false
	hint_button.disabled = false

# Funkcja zadania
func calculate_fx(x):
	return x * x * x - 2 * x - 5

# Pochodna
func calculate_dfx(x):
	return 3 * x * x - 2

func _on_calculate_button_pressed():
	if game_won:
		return
	
	if guess_input.text == "":
		result_label.text = "Wprowadź wartość!"
		return
	
	var user_guess = float(guess_input.text)
	attempts += 1
	
	# Oblicz następne przybliżenie metodą Newtona
	var fx = calculate_fx(current_guess)
	var dfx = calculate_dfx(current_guess)
	
	if abs(dfx) < 0.0001:
		result_label.text = "Błąd: pochodna bliska zera! Zacznij od nowego punktu."
		return
	
	var new_guess = current_guess - fx / dfx
	
	# Sprawdź jak blisko jest gracz
	var user_error = abs(user_guess - new_guess)
	var solution_error = abs(new_guess - correct_solution)
	
	current_guess = new_guess
	guess_label.text = "Aktualne przybliżenie: x = %.4f" % current_guess
	attempts_label.text = "Pozostało prób: %d" % (max_attempts - attempts)
	
	if user_error < tolerance:
		result_label.text = "✅ DOBRZE! Twoje obliczenia są poprawne!"
		score += 10
		score_label.text = "Wynik: %d" % score
		
		if solution_error < tolerance:
			game_won = true
			result_label.text += "\n🎉 GRATULACJE! Znalazłeś rozwiązanie: x ≈ %.4f" % current_guess
			score += 50
			score_label.text = "Wynik: %d" % score
			calculate_button.disabled = true
			hint_button.disabled = true
	else:
		result_label.text = "❌ Spróbuj jeszcze raz. Błąd w obliczeniach."
		score = max(0, score - 5)
		score_label.text = "Wynik: %d" % score
	
	if attempts >= max_attempts and not game_won:
		result_label.text = "💀 Koniec prób. Rozwiązanie to x ≈ %.4f" % correct_solution
		calculate_button.disabled = true
		hint_button.disabled = true

func _on_hint_button_pressed():
	var fx = calculate_fx(current_guess)
	var dfx = calculate_dfx(current_guess)
	result_label.text = "💡 WSKAZÓWKA:\nf(%.2f) = %.2f\nf'(%.2f) = %.2f" % [current_guess, fx, current_guess, dfx]
	score = max(0, score - 3)
	score_label.text = "Wynik: %d" % score

func _on_new_problem_button_pressed():
	# Nowe zadanie z losowym punktem startowym
	current_guess = 1.5 + randf() * 2.0
	setup_problem()
