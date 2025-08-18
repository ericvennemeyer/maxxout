class_name Paddle
extends Area2D


enum PaddleColor {RED, GREEN, BLUE, YELLOW}
@export var paddle_color: PaddleColor

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_paddle_color()


func set_paddle_color() -> void:
	match paddle_color:
		PaddleColor.RED:
			sprite_2d.modulate = Global.red
		PaddleColor.GREEN:
			sprite_2d.modulate = Global.green
		PaddleColor.BLUE:
			sprite_2d.modulate = Global.blue
		PaddleColor.YELLOW:
			sprite_2d.modulate = Global.yellow
