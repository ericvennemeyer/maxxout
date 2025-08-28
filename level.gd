extends Node2D


signal level_complete

var block_array: Array
var animation_duration: float = 1.0
var animation_delay: float = 0.0


func _ready() -> void:
	block_array = get_children()
	for block in block_array:
		block.destroyed.connect(_on_block_destroyed)
		block.scale = Vector2.ZERO
		block.modulate = Color(1.0, 1.0, 1.0, 0.0)
	
	#animate_in()


func animate_in() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_parallel()
	
	for block in block_array:
		tween.tween_property(block, "scale", Vector2(1.0, 1.0), animation_duration).set_delay(animation_delay)
		tween.tween_property(block, "modulate", Color(1.0, 1.0, 1.0, 1.0), animation_duration * 2).set_delay(animation_delay)
		animation_delay += 0.05


func _on_block_destroyed(block: Block) -> void:
	block_array.erase(block)
	if block_array.size() <= 0:
		print("Level Complete")
		level_complete.emit()
