extends Node

@export var ball_countdown: AudioStream
@export var paddle_hit: AudioStream
@export var block_hit: AudioStream
@export var block_destroy: AudioStream
@export var ball_offscreen: AudioStream
@export var level_complete: AudioStream
@export var game_over: AudioStream


func play_sfx(sfx_name: String) -> void:
	var stream: AudioStream
	match sfx_name:
		"ball_countdown":
			stream = ball_countdown
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
		audio_player.play()
		audio_player.finished.connect(audio_player.queue_free)
