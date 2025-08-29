class_name Ball
extends Area2D


#signal hit_paddle
signal offscreen(ball)

var direction: Vector2 # Set by world.gd when Ball is instantiated
var velocity: Vector2
var collided: bool = false
var other_area: Area2D
var color_data: Color

@export var active: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D


func _ready() -> void:
	sprite_2d.modulate = Global.neutral
	cpu_particles_2d.color_initial_ramp.set_color(0, Global.neutral)
	
	velocity = direction * Global.ball_speed
	
	visible_on_screen_notifier_2d.screen_exited.connect(_on_screen_exited)
	
	animation_player.play("respawn")


func _physics_process(delta: float) -> void:
	if active:
		global_position += velocity * delta
	
	if collided:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, other_area.global_position)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		#if result:
			#print(result)
			#print("Hit at point: ", result.position)
			#print("Collision normal: ", result.normal)
		if result:
			velocity = velocity.bounce(result.normal)
		
		collided = false


func _on_area_entered(area: Area2D) -> void:
	other_area = area
	
	if area is Paddle and color_data == area.color_data:
		#hit_paddle.emit()
		Global.play_sfx("paddle_hit")
		collided = true
	elif area is Block and collided == false:
		Global.play_sfx("block_hit")
		collided = true
		
		var previous_color_data = color_data
		color_data = area.color_data
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property(sprite_2d, "modulate", color_data, 0.2)
		tween.tween_method(shift_particles_color, previous_color_data, color_data, 0.2)
		
		area.destroy()


func shift_particles_color(color: Color) -> void:
	cpu_particles_2d.color_initial_ramp.set_color(0, color)


func _on_screen_exited() -> void:
	offscreen.emit(self)
