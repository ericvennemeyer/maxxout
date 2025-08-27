class_name Block
extends Area2D


signal destroyed(block: Block)

enum BlockColor {RED, GREEN, BLUE, YELLOW}
@export var block_color: BlockColor

@export var block_particles: PackedScene

var color_data: Color
var current_node_parent: Node

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	current_node_parent = get_parent()
	set_block_color()


func set_block_color() -> void:
	match block_color:
		BlockColor.RED:
			color_data = Global.red
		BlockColor.GREEN:
			color_data = Global.green
		BlockColor.BLUE:
			color_data = Global.blue
		BlockColor.YELLOW:
			color_data = Global.yellow
	
	sprite_2d.modulate = color_data


func destroy() -> void:
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.tween_property(self, "scale", scale * 1.2, 0.2)
	instantiate_particles()
	
	block_color += 1
	if block_color >= BlockColor.size():
		Global.play_sfx("block_destroy")
		destroyed.emit(self)
		tween.tween_callback(queue_free)
	else:
		set_block_color()
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)


func instantiate_particles() -> void:
	var new_particles = block_particles.instantiate()
	new_particles.position = position
	new_particles.color = color_data
	new_particles.finished.connect(func(): new_particles.queue_free())
	current_node_parent.add_child(new_particles)
	new_particles.emitting = true
