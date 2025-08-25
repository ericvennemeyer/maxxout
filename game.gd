extends Node2D

var viewport_size: Vector2
var viewport_center: Vector2
var circle_center: Vector2
var circle_radius: float

var remaining_balls: int = 3
var current_ball: Ball

@export var ball: PackedScene

@onready var balls_remaining_label: Label = $CanvasLayer/BallsRemainingLabel
@onready var win_label: Label = $CanvasLayer/WinLabel
@onready var game_over_label: Label = $CanvasLayer/GameOverLabel

@onready var camera_2d: Camera2D = $Camera2D
# This is the collision shape I'm using to define possible starting positions for the ball:
@onready var level: Node2D = $Level
@onready var circle_shape: CollisionShape2D = $BallStartZone/CircleShape


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	randomize() # Seed random number for ball start pos calculation in generate_ball_start_position()
	
	balls_remaining_label.visible = false
	win_label.visible = false
	game_over_label.visible = false
	
	level.level_complete.connect(_on_level_complete)
	
	viewport_size = get_viewport_rect().size
	viewport_center = viewport_size / 2
	
	camera_2d.global_position = viewport_center
	level.global_position = viewport_center
	circle_shape.global_position = viewport_center
	
	circle_center = circle_shape.position
	circle_radius = circle_shape.shape.radius
	
	start_new_ball_sequence()


func start_new_ball_sequence() -> void:
	if remaining_balls > 1:
		balls_remaining_label.text = str(remaining_balls) + " BALLS REMAINING"
	else:
		balls_remaining_label.text = "FINAL BALL"
	balls_remaining_label.visible = true
	await get_tree().create_timer(2.0).timeout
	balls_remaining_label.visible = false
	create_new_ball(generate_ball_start_position(circle_center, circle_radius), circle_center)


func create_new_ball(ball_start_position: Vector2, circle_center: Vector2) -> void:
	remaining_balls -= 1
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
	ball.queue_free()
	await get_tree().create_timer(1.0).timeout
	if remaining_balls > 0:
		start_new_ball_sequence()
	else:
		game_over()


func game_over() -> void:
	game_over_label.visible = true


func _on_level_complete() -> void:
	current_ball.queue_free()
	win_label.visible = true
