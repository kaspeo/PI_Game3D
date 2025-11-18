extends Control

@onready var error_label: Label = $VBoxContainer/ErrorLabel
@onready var timer_label: Label = $VBoxContainer/TimerLabel
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar


func update_progress(completed: int, total: int):
	var percent = float(completed) / float(total) * 100
	progress_bar.value = percent
	
	timer_label.text = "Postęp: %d/%d (%d%%)" % [completed, total, percent]
	error_label.text = "SEKWENCJA_URUCHAMIANIA_SYSTEMU\nInicjalizacja protokołu bezpieczeństwa..."
	
	if completed >= total:
		error_label.text = "SYSTEM_GOTOWY\nWszystkie testy bezpieczeństwa ukończone"
