extends CharacterBody2D

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var braking : float = 20

var move_input_x : float
var move_input_y : float

# 👇 UI arrows input
var ui_input : Vector2 = Vector2.ZERO

@onready var UI_Anim = $CanvasLayer/UI_animations
@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
var is_player_hit: bool = false
@onready var timer = $Timer
@onready var camera = $Camera2D
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var distance : float = 0.0

var screamOne_sfx : AudioStream = preload("res://sounds/screams/screamOne.wav")
var screamTwo_sfx : AudioStream = preload("res://sounds/screams/screamTwo.wav")
var screamThree_sfx : AudioStream = preload("res://sounds/screams/screamThree.wav")
var screamFour_sfx : AudioStream = preload("res://sounds/screams/screamFour.wav")

func _physics_process(delta):
	# 🎮 Keyboard input
	var keyboard_input := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	# ➕ Keyboard + UI arrows
	var final_input := keyboard_input + ui_input
	final_input = final_input.limit_length(1.0)


	move_input_x = final_input.x
	move_input_y = final_input.y

	if move_input_x != 0.0 or move_input_y != 0.0:
		velocity.x = lerp(velocity.x, move_input_x * move_speed, acceleration * delta)
		velocity.y = lerp(velocity.y, move_input_y * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
		velocity.y = lerp(velocity.y, 0.0, braking * delta)

	if not is_player_hit:
		move_and_slide()

func _process(_delta):
	if is_player_hit:
		collision_shape_2d.disabled = true
	else:
		if velocity.x != 0 or velocity.y != 0:
			sprite.flip_h = velocity.x < 0
		_manage_animation()

func _manage_animation():
	if move_input_x != 0 or move_input_y != 0:
		anim.play("run")
	else:
		anim.play("idle")

func player_death():
	is_player_hit = true
	timer.start()
	random_scream()
	anim.play("death")

func _on_timer_timeout() -> void:
	game_over()

func game_over():
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")

func play_sound(sound : AudioStream):
	audio.stream = sound
	audio.play()

func random_scream():
	var scream_array = [screamOne_sfx, screamTwo_sfx, screamThree_sfx, screamFour_sfx]
	randomize()
	var sfx_to_play = scream_array[randi() % scream_array.size()]
	play_sound(sfx_to_play)

# =========================
# 🔘 UI ARROW BUTTON EVENTS
# =========================

func _on_up_button_down():
	UI_Anim.play("Up Button Clicked")
	ui_input.y = -1

func _on_up_button_up():
	UI_Anim.play_backwards("Up Button Clicked")
	if ui_input.y < 0:
		ui_input.y = 0

func _on_down_button_down():
	UI_Anim.play("Down Button Clicked")
	ui_input.y = 1

func _on_down_button_up():
	UI_Anim.play_backwards("Down Button Clicked")
	if ui_input.y > 0:
		ui_input.y = 0

func _on_left_button_down():
	UI_Anim.play("Left Button Clicked")
	ui_input.x = -1

func _on_left_button_up():
	UI_Anim.play_backwards("Left Button Clicked")
	if ui_input.x < 0:
		ui_input.x = 0

func _on_right_button_down():
	UI_Anim.play("Right Button Clicked")
	ui_input.x = 1

func _on_right_button_up():
	UI_Anim.play_backwards("Right Button Clicked")
	if ui_input.x > 0:
		ui_input.x = 0
