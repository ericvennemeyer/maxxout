extends Node2D


var paddle_speed: float = 0.0


func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	var viewport_center = viewport_size / 2
	global_position = viewport_center


func _physics_process(delta: float) -> void:
	var direction: float = Input.get_axis("rotate_left", "rotate_right")
	if direction:
		accelerate(direction, delta)
	else:
		apply_friction(delta)
	rotation_degrees += paddle_speed


func accelerate(direction: float, delta: float) -> void:
	paddle_speed = move_toward(paddle_speed, Global.max_paddle_speed * direction, Global.paddle_acceleration * delta)


func apply_friction(delta: float) -> void:
	paddle_speed = move_toward(paddle_speed, 0.0, Global.paddle_friction * delta)
