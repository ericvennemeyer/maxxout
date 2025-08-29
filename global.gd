extends Node


@export_category("Colors")
@export var red: Color = Color(0.985, 0.0, 0.326)
@export var green: Color = Color(0.6, 0.931, 0.0)
@export var blue: Color = Color(0.0, 0.783, 1.0)
@export var yellow: Color = Color(1.0, 0.967, 0.0)
@export var neutral: Color = Color(0.758, 0.758, 0.758)
@export var faded_in: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var faded_out: Color = Color(1.0, 1.0, 1.0, 0.0)

@export_category("Movement Parameters")
@export var ball_speed: float = 400.0
@export var max_paddle_speed: float = 90.0
@export var paddle_acceleration: float = 30.0
@export var paddle_friction: float = 100.0

@export_category("SFX")
@export var paddle_hit: AudioStream
@export var block_hit: AudioStream
@export var block_destroy: AudioStream
@export var ball_offscreen: AudioStream
@export var level_complete: AudioStream
@export var game_over: AudioStream


func play_sfx(sfx_name: String) -> void:
	var stream: AudioStream
	match sfx_name:
		"paddle_hit":
			stream = paddle_hit
		"block_hit":
			stream = block_hit
		"block_destroy":
			stream = block_destroy
		"ball_offscreen":
			stream = ball_offscreen
		"level_complete":
			stream = level_complete
		"game_over":
			stream = game_over
	
	if stream:
		var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
		audio_player.stream = stream
		add_child(audio_player)
		audio_player.play()
		audio_player.finished.connect(audio_player.queue_free)
	else:
		print("%s is not a valid AudioStream" %stream)
