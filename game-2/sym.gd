extends TextureRect

const color_red = Color("#f8566b")
const color_green = Color("#27bb99")
const sym_text = {
	"btc": "BTC Bitcoin",
	"eth": "ETH Ethereum",
}
const kwidth = 10
var graph_size
var kdata = []
var sock = WebSocketPeer.new()

func _ready() -> void:
	var sym = self.get_meta("sym")
	$icon.texture = load("res://assets/" + sym + ".png")
	$name.text = sym_text[sym]
	graph_size = $graph.size
	var limit = int(graph_size.x / (2 * kwidth))
	var url = "https://api.binance.com/api/v3/klines?symbol=%sUSDT&interval=15m&limit=%d" % [sym.to_upper(), limit]
	$kline.request(url)

func _process(_delta):
	sock.poll()
	var state = sock.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while sock.get_available_packet_count():
			var pack = sock.get_packet()
			var json = JSON.parse_string(pack.get_string_from_utf8())
			var kline = json["data"]["k"]
			var k = {
				"o": float(kline["o"]),
				"h": float(kline["h"]),
				"l": float(kline["l"]),
				"c": float(kline["c"]),
			}
			if kdata[-1]["o"] == k["o"]:
				kdata[-1] = k
			else:
				kdata.pop_front()
				kdata.append(k)
			_draw_kline()

func _on_kline_req_done(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	for kline in json:
		var k = {
			"o": float(kline[1]),
			"h": float(kline[2]),
			"l": float(kline[3]),
			"c": float(kline[4]),
		}
		kdata.append(k)
	$arrow.visible = true
	_draw_kline()

	var sym = self.get_meta("sym")
	var url = "wss://stream.binance.com:9443/stream?streams=" + sym + "usdt@kline_1m"
	sock.connect_to_url(url)

func _price_to_y(price: float, min_p: float, max_p: float, chart_h: float) -> float:
	var t = (price - min_p) / (max_p - min_p)
	return (1.0 - t) * chart_h

func _draw_kline() -> void:
	var min_p = 1e18
	var max_p = -1e18
	for c in kdata:
		if c["h"] > max_p: max_p = c["h"]
		if c["l"] < min_p: min_p = c["l"]

	var krect = []
	for i in range(kdata.size()):
		var c = kdata[i]
		var x = 2 * i * kwidth
		var y_open = _price_to_y(c["o"], min_p, max_p, graph_size.y)
		var y_close = _price_to_y(c["c"], min_p, max_p, graph_size.y)
		var y_high = _price_to_y(c["h"], min_p, max_p, graph_size.y)
		var y_low = _price_to_y(c["l"], min_p, max_p, graph_size.y)
		
		var k = {}
		var body_t = min(y_open, y_close)
		var body_b = max(y_open, y_close)
		var body_h = body_b - body_t
		k["p"] = Rect2(x, body_t, kwidth, body_h)
		if c["c"] >= c["o"]:
			k["c"] = color_green
		else:
			k["c"] = color_red

		var candle_x = x + 0.5 * kwidth
		var candle_t = min(y_low, y_high)
		var candle_b = max(y_low, y_high)
		var candle_h = candle_b - candle_t
		k["k"] = Rect2(candle_x, candle_t, 1, candle_h)
		krect.append(k)
	$graph.set_meta("krect", krect)
	$graph.queue_redraw()

	var last_kline = kdata[-1]
	var open = last_kline["o"]
	var close = last_kline["c"]
	var diff = close - open
	var color

	if close >= open:
		$status/text.text = "PUMP"
		$arrow.rotation = 0
		color = color_green
	else:
		$status/text.text = "DUMP"
		$arrow.rotation_degrees = 180
		color = color_red

	$status.color = color
	$arrow.modulate = color
	$percent_diff.modulate = color

	$price.text = "%.2f$" % [close]
	$price_diff.text = "%.2f$" % [diff]
	$percent_diff.text = "%.2f%%" % [100 * diff / open]
