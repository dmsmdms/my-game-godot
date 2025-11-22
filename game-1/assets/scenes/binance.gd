extends HTTPRequest

signal kdata_received

const BASE_HTTP_URL := "https://api.binance.com/api/v3/klines?interval=15m&"
const BASE_WS_URL := "wss://stream.binance.com:9443/stream?"

var ws := WebSocketPeer.new()
var kdata := []

func _ready() -> void:
	set_process(false)

func ws_proc_msg() -> void:
	while ws.get_available_packet_count():
		var pack = ws.get_packet()
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
		kdata_received.emit(kdata)

func start(limit: int) -> void:
	var symbol: String = get_meta("symbol")
	var url = BASE_HTTP_URL + "symbol=%sUSDT&limit=%d" % [symbol.to_upper(), limit]
	request(url)

func _process(_delta: float) -> void:
	ws.poll()
	var state = ws.get_ready_state()
	match state:
		WebSocketPeer.STATE_OPEN:
			ws_proc_msg()

func _on_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.parse_string(body.get_string_from_utf8())
	for kline in json:
		var k = {
			"o": float(kline[1]),
			"h": float(kline[2]),
			"l": float(kline[3]),
			"c": float(kline[4]),
		}
		kdata.append(k)
	kdata_received.emit(kdata)

	var symbol: String = get_meta("symbol")
	var url := BASE_WS_URL + "streams=" + symbol + "usdt@kline_1m"
	ws.connect_to_url(url)
	set_process(true)
