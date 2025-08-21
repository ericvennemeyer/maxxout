class_name Ball
extends Area2D

var direction: Vector2
var velocity: Vector2
var collided: bool = false
var other_area: Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.modulate = Global.neutral
	
	direction = Vector2.RIGHT.rotated(randf() * TAU)
	velocity = direction * Global.ball_speed


func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
	if collided:
		print("Collided")
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, other_area.global_position)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			print("Hit at point: ", result.position)
			print("Collision normal: ", result.normal)
		
		velocity = velocity.bounce(result.normal)
		
		collided = false


func _on_area_entered(area: Area2D) -> void:
	collided = true
	other_area = area
	
	if area is Paddle:
		print("Hit Paddle")
	elif area is Block:
		area.destroy()
		
		var tween = get_tree().create_tween()
		tween.tween_property(sprite_2d, "modulate", area.sprite_2d.modulate, 0.2)
