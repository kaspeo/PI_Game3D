extends Node

var unlocked_levels: int = 1
const TOTAL_LEVELS: int = 10
const SAVE_PATH: String = "user://progress.save"

func _ready():
	load_progress()

func unlock_next_level():
	if unlocked_levels < TOTAL_LEVELS:
		unlocked_levels += 1
		save_progress()

func complete_level(level_number: int):
	if level_number == unlocked_levels:
		unlock_next_level()

func save_progress():
	var save_data = {
		"unlocked_levels": unlocked_levels
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save_data)

func load_progress():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var save_data = file.get_var()
		unlocked_levels = save_data["unlocked_levels"]
	else:
		unlocked_levels = 1
		save_progress()

func reset_progress():
	unlocked_levels = 1
	save_progress()
