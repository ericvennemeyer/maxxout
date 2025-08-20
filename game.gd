extends Node2D

var viewport_size: Vector2
var viewport_center: Vector2

@export var ball: PackedScene


func _ready() -> void:
	viewport_size = get_viewport_rect().size
	viewport_center = viewport_size / 2
	create_new_ball(viewport_center)


func create_new_ball(ball_start_position: Vector2) -> void:
	var new_ball = ball.instantiate()
	new_ball.global_position = ball_start_position
	add_child(new_ball)
	
