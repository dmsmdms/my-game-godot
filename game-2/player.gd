extends CharacterBody2D

const POS_Y_START := 1200.0
const POS_Y_LOW := 2000.0
const JUMP_VELOCITY_MIN := -600.0
const JUMP_VELOCITY_MAX := -1800.0
const ROT_FACTOR := 0.015
const X_DIR_CHANGE_TIME := 3.0
const X_VELOCITY := -100.0

@onready var color_rect: Panel = $ColorRect

var x_dir_change_time := 0.0

func _ready() -> void:
	velocity.x = X_VELOCITY

func _process(_delta: float) -> void:
	if position.y > POS_Y_LOW:
		position.y = POS_Y_START

func _physics_process(delta: float) -> void:
	if x_dir_change_time > X_DIR_CHANGE_TIME:
		velocity.x = -velocity.x
		x_dir_change_time = 0.0
	x_dir_change_time += delta

	if is_on_floor():
		velocity.y = randf_range(JUMP_VELOCITY_MIN, JUMP_VELOCITY_MAX)
	else:
		velocity += get_gravity() * delta
	color_rect.rotation = ROT_FACTOR * velocity.y * delta
	move_and_slide()
