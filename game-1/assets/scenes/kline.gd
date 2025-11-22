extends Control

const COLOR_RED := Color("#f8566b")
const COLOR_GREEN := Color("#27bb99")

@onready var binance: HTTPRequest = $Binance

var kdata := []

func _ready() -> void:
	var kwidth: float = get_meta("kwidth")
	var limit := int(0.5 * size.x / kwidth)
	binance.start(limit)

func price_to_y(price: float, min_p: float, max_p: float, chart_h: float) -> float:
	var t = (price - min_p) / (max_p - min_p)
	return (1.0 - t) * chart_h

func _draw() -> void:
	var min_p := 1e18
	var max_p := -1e18
	for c in kdata:
		if c["h"] > max_p: max_p = c["h"]
		if c["l"] < min_p: min_p = c["l"]

	var kwidth: float = get_meta("kwidth")
	for i in range(len(kdata)):
		var c: Dictionary = kdata[i]
		var x := 2 * i * kwidth
		var y_open := price_to_y(c["o"], min_p, max_p, size.y)
		var y_close := price_to_y(c["c"], min_p, max_p, size.y)
		var y_high := price_to_y(c["h"], min_p, max_p, size.y)
		var y_low := price_to_y(c["l"], min_p, max_p, size.y)

		var body_t: float = min(y_open, y_close)
		var body_b: float = max(y_open, y_close)
		var body_h := body_b - body_t
		var rect := Rect2(x, body_t, kwidth, body_h)
		var color := COLOR_GREEN if c["c"] >= c["o"] else COLOR_RED
		draw_rect(rect, color)

		var candle_x := x + 0.5 * kwidth
		var candle_t: float = min(y_low, y_high)
		var candle_b: float = max(y_low, y_high)
		var candle_h := candle_b - candle_t
		rect = Rect2(candle_x, candle_t, 1, candle_h)
		draw_rect(rect, color)

func _on_kdata_received(new_kdata: Array) -> void:
	kdata = new_kdata
	queue_redraw()
