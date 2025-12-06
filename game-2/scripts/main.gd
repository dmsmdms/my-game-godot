extends Node2D

const PLATORM := preload("res://scenes/platform.tscn")
const PLATFORM_COUNT := 8
const COLOR_CHANGE_SPEED := 2.0
const COLOR_RED = Color("#f8566b")
const COLOR_GREEN = Color("#27bb99")

@onready var player_rect: Panel = $Player/ColorRect

var color := Color.WHITE
var dst_color := Color.WHITE
var platforms := []

func set_panel_color(obj: Panel, obj_color: Color) -> void:
	var sb: StyleBoxFlat = obj.get_theme_stylebox("panel")
	sb.bg_color = obj_color
	obj.add_theme_stylebox_override("panel", sb)

func _ready() -> void:
	randomize()
	for i in range(PLATFORM_COUNT):
		var platform := PLATORM.instantiate()
		platforms.push_back(platform)
		add_child(platform)

func _process(delta: float) -> void:
	if dst_color != color:
		color = lerp(color, dst_color, delta * COLOR_CHANGE_SPEED)
		set_panel_color(player_rect, color)

		for i in range(PLATFORM_COUNT):
			var rect: Panel = platforms[i].get_node("ColorRect")
			set_panel_color(rect, color)

func _on_kdata_ready(kdata: Array) -> void:
	var k: Dictionary = kdata[-1]
	dst_color = COLOR_RED if k["c"] < k["o"] else COLOR_GREEN
