extends CharacterBody2D

const SPEED := 300.0
const JUMP_VELOCITY := -2000.0

var jump_count := 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = JUMP_VELOCITY
		jump_count = 0

	if Input.is_action_just_pressed("jump") and jump_count < 2:
		jump_count += 1
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
