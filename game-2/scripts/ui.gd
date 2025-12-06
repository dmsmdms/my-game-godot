extends Control

const TEX := [
	preload("res://assets/sun.png"),
	preload("res://assets/moon.png")
]

const X_SPEED := 80.0
const X_MIN := -100.0
const X_MAX := 1000.0
const Y_DIST := -800.0
const Y_OFFSET := 1000.0
const SCALE := 0.4
const STARS_POS_X_HIDE := 400.0

@onready var stars: Control = $btc/stars
@onready var sun: TextureRect = $btc/sun

var tex_idx := 0

func _ready() -> void:
	sun.position.x = X_MIN
	sun.texture = TEX[tex_idx]
	stars.modulate.a = 0

func _process(delta: float) -> void:
	if sun.position.x > X_MAX:
		tex_idx = (tex_idx + 1) % 2
		sun.texture = TEX[tex_idx]
		sun.position.x = X_MIN
		sun.scale = Vector2(SCALE, SCALE)

	if tex_idx > 0:
		stars.modulate.a = 1.0 - 0.002 * abs(sun.position.x - STARS_POS_X_HIDE)
	else:
		stars.modulate.a = 0

	sun.position.x += X_SPEED * delta
	sun.position.y = Y_DIST * sin(0.003 * sun.position.x + 0.3) + Y_OFFSET
	
