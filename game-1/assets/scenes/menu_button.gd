extends Button

const X_OFFSET := 26.0
const LINE_WIDTH := 2.0
const PARALLELEPIPED_EXT2_LINE_MARGIN_X := 20.0
const PARALLELEPIPED_EXT2_LINE_K := 0.75
const TEXT_COLOR_HOVER := Color("3b4048")
const COLOR_HOVER := Color("f0f0f0")

@onready var label: Label = $Label

var is_hover := false
var draw_func := [
	draw_parallelepiped,
	draw_parallelepiped_ext2,
	draw_trapezoid,
]

func draw_parallelepiped(color: Color) -> Array:
	var base_offset := Vector2(LINE_WIDTH, LINE_WIDTH) / 2.0
	var real_size := size - 2.0 * base_offset
	real_size.x -= X_OFFSET
	var points := [
		base_offset + Vector2(X_OFFSET, 0),
		base_offset + Vector2(X_OFFSET + real_size.x, 0),
		base_offset + Vector2(real_size.x, real_size.y),
		base_offset + Vector2(0, real_size.y),
	]
	draw_polyline(points + [points[0]], color, LINE_WIDTH, true)
	return points

func draw_parallelepiped_ext2(color: Color) -> Array:
	var margin_x = PARALLELEPIPED_EXT2_LINE_MARGIN_X + LINE_WIDTH
	var base_offset := Vector2(margin_x, LINE_WIDTH) / 2.0
	var real_size := size - 2.0 * base_offset
	real_size.x -= X_OFFSET
	var ext_line_size := PARALLELEPIPED_EXT2_LINE_K * Vector2(X_OFFSET, real_size.y)
	var points := [
		base_offset + Vector2(0, 0),
		base_offset + Vector2(real_size.x, 0),
		base_offset + Vector2(X_OFFSET + real_size.x, real_size.y),
		base_offset + Vector2(X_OFFSET, real_size.y),
	]
	draw_polyline(points + [points[0]], color, LINE_WIDTH, true)

	var p1 := Vector2(LINE_WIDTH, LINE_WIDTH)
	var p2 := p1 + ext_line_size
	draw_line(p1, p2, color, LINE_WIDTH, true)
	p1 = size - Vector2(LINE_WIDTH, LINE_WIDTH)
	p2 = p1 - ext_line_size
	draw_line(p1, p2, color, LINE_WIDTH, true)
	return points

func draw_trapezoid(color: Color) -> Array:
	var base_offset := Vector2(LINE_WIDTH, LINE_WIDTH) / 2.0
	var real_size := size - 2.0 * base_offset
	real_size.x -= X_OFFSET
	var points := [
		base_offset + Vector2(X_OFFSET, 0),
		base_offset + Vector2(real_size.x, 0),
		base_offset + Vector2(real_size.x + X_OFFSET, real_size.y),
		base_offset + Vector2(0, real_size.y),
	]
	draw_polyline(points + [points[0]], color, LINE_WIDTH, true)
	return points

func _draw() -> void:
	var type: int = get_meta("type")
	var color: Color = COLOR_HOVER if is_hover else get_meta("color")
	var points: Array = draw_func[type].call(color)
	if is_hover:
		var colors := PackedColorArray()
		colors.resize(4)
		colors.fill(color)
		draw_polygon(points, colors)

func _on_mouse_entered() -> void:
	is_hover = true
	label.add_theme_color_override("font_color", TEXT_COLOR_HOVER)
	queue_redraw()

func _on_mouse_exited() -> void:
	is_hover = false
	label.remove_theme_color_override("font_color")
	queue_redraw()
