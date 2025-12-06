extends StaticBody2D

const SPEED := 200.0
const LEFT_LIMIT := -200.0
const RESET_POS_X := 1600.0

@onready var color_rect: ColorRect = $ColorRect

func _process(delta: float) -> void:
	position.x -= SPEED * delta
	if position.x + color_rect.size.x < LEFT_LIMIT:
		position.x = RESET_POS_X
