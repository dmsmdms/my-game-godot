extends Node3D

const MOUSE_SENSITIVITY: float = 0.005
const MOUSE_CLAMP: float = 30.0

var mouse_angle_x := 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_angle_x += -event.relative.y * MOUSE_SENSITIVITY
		mouse_angle_x = clamp(mouse_angle_x, deg_to_rad(-MOUSE_CLAMP), deg_to_rad(MOUSE_CLAMP))
		rotation.x = mouse_angle_x
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
