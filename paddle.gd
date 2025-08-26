class_name Paddle
extends Area2D

var color_data: Color

enum PaddleColor {RED, GREEN, BLUE, YELLOW}
@export var paddle_color: PaddleColor

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
