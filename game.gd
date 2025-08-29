extends Node2D

var viewport_size: Vector2
var viewport_center: Vector2
var circle_center: Vector2
var circle_radius: float

var current_level
var default_music_volume: float

var total_balls: int = 3
var played_balls: int = 0
var current_ball: Ball

@export var ball: PackedScene
@export var level: PackedScene

@onready var main_menu: CanvasLayer = $MainMenu

@onready var balls_remaining_label: Label = $CanvasLayer/MarginContainer/Control/BallsRemainingLabel
@onready var win_label: Label = $CanvasLayer/MarginContainer/WinLabel
#@onready var game_over_label: Label = $CanvasLayer/GameOverLabel

@onready var camera_2d: Camera2D = $Camera2D
# This is the collision shape I'm using to define possible starting positions for the ball:
@onready var paddle_ring: Node2D = $Paddle_Ring
@onready var circle_shape: CollisionShape2D = $BallStartZone/CircleShape
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var starfield: CPUParticles2D = $Starfield
@onready var intro_sequence_player: AnimationPlayer = $IntroSequencePlayer

@onready var game_over_container: PanelContainer = $CanvasLayer/MarginContainer/GameOverContainer
@onready var play_again_button: Button = $CanvasLayer/MarginContainer/GameOverContainer/GameOverVBox/PlayAgainButton


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	randomize() # Seed random number for ball start pos calculation in generate_ball_start_position()
	
	default_music_volume = music_player.volume_db
	
	balls_remaining_label.visible = false
	win_label.visible = false
	game_over_container.visible = false
	#game_over_label.visible = false
	
	play_again_button.disabled = true
	
	main_menu.start_game.connect(func():
		main_menu.queue_free()
		intro_sequence_player.play("intro_sequence")
		)
	
	viewport_size = get_viewport_rect().size
	viewport_center = viewport_size / 2
	
	camera_2d.global_position = viewport_center
	circle_shape.global_position = viewport_center
	starfield.global_position = viewport_center
	
	circle_center = circle_shape.position
	circle_radius = circle_shape.shape.radius


func instantiate_level() -> void:
	current_level = level.instantiate()
	current_level.global_position = viewport_center
	#new_level.block_destroyed.connect(_on_block_destroyed)
	current_level.level_complete.connect(_on_level_complete)
	add_child(current_level)
	current_level.animate_in()


func animate_screen_text(text_node: Control) -> void:
	text_node.visible = true
	text_node.modulate = Global.faded_out
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_parallel()
	tween.tween_property(text_node, "position", Vector2(position.x, position.y - 275), 1.5)
	tween.tween_property(text_node, "modulate", Global.faded_in, 1.0)
	tween.chain().tween_property(text_node, "modulate", Global.faded_out, 0.5).set_delay(0.5)
	await tween.finished
	text_node.visible = false


func start_new_ball_sequence() -> void:
	played_balls += 1
	if played_balls < total_balls:
		balls_remaining_label.text = "BALL 0" + str(played_balls)
	else:
		balls_remaining_label.text = "FINAL BALL"
	var initial_label_position = balls_remaining_label.position
	animate_screen_text(balls_remaining_label)
	await get_tree().create_timer(2.5).timeout
	balls_remaining_label.position = initial_label_position
	create_new_ball(generate_ball_start_position(circle_center, circle_radius), circle_center)


func create_new_ball(ball_start_position: Vector2, circle_center: Vector2) -> void:
	var new_ball = ball.instantiate()
	current_ball = new_ball
	new_ball.offscreen.connect(_on_ball_left_screen)
	new_ball.global_position = ball_start_position
	# Make sure ball is moving toward center of playfield at start:
	new_ball.direction = new_ball.global_position.direction_to(circle_center)
	add_child(new_ball)


func generate_ball_start_position(circle_center: Vector2, circle_radius: float) -> Vector2:
	# Pulled the following from a google AI overview on how to
	# generate a random point on circumference of a circle
	var random_angle = randf() * TAU
	var x = circle_radius * cos(random_angle)
	var y = circle_radius * sin(random_angle)
	return circle_center + Vector2(x, y)


func _on_ball_left_screen(ball: Ball) -> void:
	Global.play_sfx("ball_offscreen")
	camera_2d.apply_noise_shake(20.0, 30.0)
	ball.queue_free()
	await get_tree().create_timer(1.0).timeout
	if played_balls < total_balls:
		start_new_ball_sequence()
	else:
		game_over()


func _on_block_destroyed() -> void:
	camera_2d.apply_noise_shake(10.0, 5.0, 2.0)


func game_over() -> void:
	game_over_container.visible = true
	game_over_container.modulate = Global.faded_out
	play_again_button.disabled = false
	play_again_button.grab_focus()
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(music_player, "volume_db", -80.0, 1.0)
	tween.tween_property(game_over_container, "modulate", Global.faded_in, 0.5)
	Global.play_sfx("game_over")


func _on_level_complete() -> void:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80.0, 1.0)
	Global.play_sfx("level_complete")
	current_ball.queue_free()
	win_label.visible = true
	animate_screen_text(win_label)


func restart_game() -> void:
	game_over_container.visible = false
	play_again_button.disabled = true
	
	played_balls = 0
	paddle_ring.rotation_degrees = 0.0
	music_player.volume_db = default_music_volume
	
	current_level.queue_free()
	instantiate_level()
	await get_tree().create_timer(1.5).timeout
	start_new_ball_sequence()


func _on_play_again_button_pressed() -> void:
	restart_game()
