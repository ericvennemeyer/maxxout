class_name Ball
extends Area2D

var direction: int = 1

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.modulate = Global.neutral


func _physics_process(delta: float) -> void:
	global_position += Vector2.RIGHT * Global.ball_velocity * delta * direction


func _on_area_entered(area: Area2D) -> void:
	if area is Paddle:
		print("Hit Paddle")
		sprite_2d.modulate = area.sprite_2d.modulate
		direction *= -1
