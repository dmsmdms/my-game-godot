extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -2000.0
const MOVE_X_STEP := 10.0

var move_dir_x := 0.0
var jump_count := 0
var is_jump := false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = JUMP_VELOCITY
		jump_count = 0

	if (Input.is_action_just_pressed("jump") || is_jump) and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY
		is_jump = false

	var direction := Input.get_axis("left", "right") + move_dir_x
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_dir_x = 0.0
	move_and_slide()

func _on_right_pressed() -> void:
	move_dir_x += MOVE_X_STEP

func _on_left_pressed() -> void:
	move_dir_x -= MOVE_X_STEP

func _on_jump_pressed() -> void:
	is_jump = true
