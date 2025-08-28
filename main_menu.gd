extends CanvasLayer


signal start_game

var color_animation_duration: float = 1.0

var faded_in: Color = Color(1.0, 1.0, 1.0, 1.0)
var faded_out: Color = Color(1.0, 1.0, 1.0, 0.0)
var fade_duration: float = 0.5

@onready var intro_screen: MarginContainer = $IntroScreen
@onready var instructions_screen: MarginContainer = $InstructionsScreen

@onready var x: Label = $IntroScreen/VBoxContainer/HBoxContainer/X
@onready var x_2: Label = $IntroScreen/VBoxContainer/HBoxContainer/X2

@onready var start_button: Button = $IntroScreen/VBoxContainer/StartButton
@onready var instructions_button: Button = $IntroScreen/VBoxContainer/InstructionsButton
@onready var quit_button: Button = $IntroScreen/VBoxContainer/QuitButton
@onready var back_button: Button = $InstructionsScreen/VBoxContainer/BackButton


func _ready() -> void:
	intro_screen.visible = true
	intro_screen.modulate = faded_in
	instructions_screen.visible = true
	instructions_screen.modulate = faded_out
	
	x.modulate = Global.green
	x_2.modulate = Global.yellow
	
	animate_title_colors()
	
	start_button.grab_focus()
	back_button.disabled = true


func animate_title_colors() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(x, "modulate", Global.blue, color_animation_duration)
	tween.tween_property(x_2, "modulate", Global.red, color_animation_duration)
	tween.tween_property(x, "modulate", Global.green, color_animation_duration)
	tween.tween_property(x_2, "modulate", Global.yellow, color_animation_duration)


func _on_start_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(intro_screen, "modulate", faded_out, fade_duration * 2)
	tween.tween_callback(start_game.emit)


func _on_instructions_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(intro_screen, "modulate", faded_out, fade_duration)
	tween.tween_property(instructions_screen, "modulate", faded_in, fade_duration)
	start_button.disabled = true
	instructions_button.disabled = true
	quit_button.disabled = true
	back_button.disabled = false
	
	back_button.grab_focus()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(instructions_screen, "modulate", faded_out, fade_duration)
	tween.tween_property(intro_screen, "modulate", faded_in, fade_duration)
	start_button.disabled = false
	instructions_button.disabled = false
	quit_button.disabled = false
	back_button.disabled = true
	
	start_button.grab_focus()
