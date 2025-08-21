extends Node2D

var viewport_size: Vector2
var viewport_center: Vector2

@export var ball: PackedScene

@onready var collision_shape_2d: CollisionShape2D = $BallExclusionZone/CollisionShape2D


func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	
	viewport_size = get_viewport_rect().size
	viewport_center = viewport_size / 2
	
	create_new_ball(generate_ball_start_position())


func create_new_ball(ball_start_position: Vector2) -> void:
	var new_ball = ball.instantiate()
	new_ball.global_position = ball_start_position
	add_child(new_ball)


func generate_ball_start_position() -> Vector2:
	var zone_center: Vector2 = collision_shape_2d.position
	var zone_size: Vector2 = collision_shape_2d.shape.size
	
	var random_x_low = randi_range(0, zone_center.x - zone_size.x / 2)
	# TODO: Need to subtract eventual paddle width:
	var random_x_high = randi_range(zone_center.x + zone_size.x / 2, viewport_size.x - 50)
	var random_y_low = randi_range(0, zone_center.y - zone_size.y / 2)
	# TODO: Need to subtract eventual paddle width:
	var random_y_high = randi_range(zone_center.y + zone_size.y / 2, viewport_size.y - 50)
	
	var x_pos: Array = [random_x_low, random_x_high]
	var y_pos: Array = [random_y_low, random_y_high]
	
	var ball_start_position: Vector2 = Vector2(x_pos[randi_range(0, 1)], y_pos[randi_range(0, 1)])
	
	return ball_start_position
