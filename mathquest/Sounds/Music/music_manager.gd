extends Node

var player := AudioStreamPlayer.new()
var current_track_path: String = ""

func _ready():
	add_child(player)
	player.bus = "Music"
	player.volume_db = -6
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
