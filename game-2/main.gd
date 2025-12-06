extends Node2D

const PLATORM := preload("res://platform.tscn")
const PLATFORM_COUNT := 8
const PLATFROM_DIST_X := 250.0
const PLATFROM_BASE_Y := 1400.0
const COLOR_CHANGE_SPEED := 2.0
const COLOR_RED = Color("#f8566b")
const COLOR_GREEN = Color("#27bb99")

@onready var player_rect: Panel = $Player/ColorRect

var color := Color.WHITE
var dst_color := Color.WHITE
var platforms := []

func _ready() -> void:
	var last_pos := Vector2.ZERO
	for i in range(PLATFORM_COUNT):
		var platform := PLATORM.instantiate()
		last_pos.x += PLATFROM_DIST_X
		last_pos.y = PLATFROM_BASE_Y
		platform.position = last_pos
		platforms.push_back(platform)
		add_child(platform)

func _process(delta: float) -> void:
	if dst_color != color:
		color = lerp(color, dst_color, delta * COLOR_CHANGE_SPEED)

		var sb: StyleBoxFlat = player_rect.get_theme_stylebox("panel")
		sb.bg_color = color
		player_rect.add_theme_stylebox_override("panel", sb)

		for i in range(PLATFORM_COUNT):
			var rect: ColorRect = platforms[i].get_node("ColorRect")
			rect.color = color

func _on_kdata_ready(kdata: Array) -> void:
	var k: Dictionary = kdata[-1]
	dst_color = COLOR_RED if k["c"] < k["o"] else COLOR_GREEN
