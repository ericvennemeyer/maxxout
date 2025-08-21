class_name Block
extends Area2D


enum BlockColor {RED, GREEN, BLUE, YELLOW}
@export var block_color: BlockColor

var color_data: Color

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_paddle_color()


func set_paddle_color() -> void:
	match block_color:
		BlockColor.RED:
			color_data = Global.red
			sprite_2d.modulate = color_data
		BlockColor.GREEN:
			color_data = Global.green
			sprite_2d.modulate = color_data
		BlockColor.BLUE:
			color_data = Global.blue
			sprite_2d.modulate = color_data
		BlockColor.YELLOW:
			color_data = Global.yellow
			sprite_2d.modulate = color_data


func destroy() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", scale * 1.2, 0.2)
	tween.tween_callback(queue_free)
