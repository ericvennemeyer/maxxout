extends Node2D


signal level_complete

var block_array: Array


func _ready() -> void:
	block_array = get_children()
	for block in block_array:
		block.destroyed.connect(_on_block_destroyed)


func _on_block_destroyed(block: Block) -> void:
	block_array.erase(block)
	if block_array.size() <= 0:
		print("Level Complete")
		level_complete.emit()
