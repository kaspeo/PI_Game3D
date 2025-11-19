extends Node

var player: AudioStreamPlayer
var current_track_path: String = ""
var music_volume: float = -6.0

func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
	player.bus = "Music"
	player.volume_db = music_volume
	player.autoplay = false

func play_music(path: String, fade_time := 0.5) -> void:
	if current_track_path == path:
		return 

	current_track_path = path

	var new_stream = load(path)
	if new_stream == null:
		push_error("Failed to load audio stream: " + path)
		return

	if player.playing:
		await fade_out_in(new_stream, fade_time)
	else:
		player.stream = new_stream
		player.play()

func fade_out_in(new_stream: AudioStream, time: float) -> void:
	var start_vol = player.volume_db
	var steps = max(1, int(time * 60)) 
	var step_duration = time / steps
	
	for i in range(steps + 1):
		player.volume_db = lerp(start_vol, -40.0, float(i) / steps)
		await get_tree().create_timer(step_duration).timeout

	player.stream = new_stream
	player.play()

	for i in range(steps + 1):
		player.volume_db = lerp(-40.0, start_vol, float(i) / steps)
		await get_tree().create_timer(step_duration).timeout

func set_music_volume(volume_percent: float) -> void:
	if volume_percent == 0:
		music_volume = -80.0
	else:
		music_volume = lerp(-40.0, 0.0, volume_percent / 100.0)
	player.volume_db = music_volume

func get_music_volume() -> float:
	return inverse_lerp(-40.0, 0.0, music_volume) * 100.0
	
func play_computer_sound():
	var computer_sound = AudioStreamPlayer.new()
	add_child(computer_sound)
	computer_sound.stream = load("res://Sounds/Computer/ComputersPopUp.ogg")
	computer_sound.volume_db = music_volume
	computer_sound.play()
	await computer_sound.finished
	computer_sound.queue_free()
