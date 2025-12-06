extends StaticBody2D

const SPEED := 200.0
const LEFT_LIMIT := -200.0
const RESET_POS_X := 1600.0
const DIST_X := 250.0
const DIST_Y_MAX := 200.0
const BASE_Y := 1400.0

@onready var color_rect: Panel = $ColorRect
@onready var triangle: Sprite2D = $Triangle/Sprite2D

static var last_pos_x := 0.0

func get_y_pos() -> float:
	last_pos_x += DIST_X
	return BASE_Y + DIST_Y_MAX * sin(0.001 * last_pos_x + 0.4 * randf() - 0.2)

func set_triangle() -> void:
	triangle.visible = !randi_range(0, 1)

func _ready() -> void:
	position.x = last_pos_x
	position.y = get_y_pos()
	set_triangle()

func _process(delta: float) -> void:
	position.x -= SPEED * delta
	if position.x + color_rect.size.x < LEFT_LIMIT:
		position.x = RESET_POS_X
		position.y = get_y_pos()
		set_triangle()
