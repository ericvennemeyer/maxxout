extends Node2D

var viewport_size: Vector2
var viewport_center: Vector2

@export var ball: PackedScene

@onready var camera_2d: Camera2D = $Camera2D
# This is the collision shape I'm using to define possible starting positions for the ball:
@onready var circle_shape: CollisionShape2D = $BallStartZone/CircleShape


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	randomize() # Seed random number for ball start pos calculation in generate_ball_start_position()
	
	viewport_size = get_viewport_rect().size
	viewport_center = viewport_size / 2
	
	camera_2d.global_position = viewport_center
	
	var circle_center: Vector2 = circle_shape.position
	var circle_radius: float = circle_shape.shape.radius
	create_new_ball(generate_ball_start_position(circle_center, circle_radius), circle_center)


func create_new_ball(ball_start_position: Vector2, circle_center: Vector2) -> void:
	var new_ball = ball.instantiate()
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
