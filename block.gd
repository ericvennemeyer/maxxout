class_name Block
extends Area2D


signal destroyed(block: Block)

enum BlockColor {RED, GREEN, BLUE, YELLOW}
@export var block_color: BlockColor

var color_data: Color

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	set_block_color()


func set_block_color() -> void:
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
	
	block_color += 1
	if block_color >= BlockColor.size():
		destroyed.emit(self)
		tween.tween_callback(queue_free)
	else:
		set_block_color()
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
