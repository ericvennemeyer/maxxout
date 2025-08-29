class_name Paddle
extends Area2D

var color_data: Color

enum PaddleColor {RED, GREEN, BLUE, YELLOW}
@export var paddle_color: PaddleColor
@export var pop_scale: Vector2 = Vector2(1.3, 1.2)
@export var pop_duration: float = 0.25

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_paddle_color()


func set_paddle_color() -> void:
	match paddle_color:
		PaddleColor.RED:
			color_data = Global.red
		PaddleColor.GREEN:
			color_data = Global.green
		PaddleColor.BLUE:
			color_data = Global.blue
		PaddleColor.YELLOW:
			color_data = Global.yellow
	
	sprite_2d.modulate = color_data


func animate_paddle_pop() -> void:
	var default_scale: Vector2 = scale
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", pop_scale, pop_duration / 2)
	tween.tween_property(self, "scale", default_scale, pop_duration / 3)
