extends Control

const COLOR_RED := Color("#f8566b")
const COLOR_GREEN := Color("#27bb99")

@onready var price: Label = $Price
@onready var change_price: Label = $ChangePrice
@onready var change_percent: Label = $ChangePercent

func _on_kdata_received(kdata: Array) -> void:
	var k: Dictionary = kdata[-1]
	var open: float = k["o"]
	var close: float = k["c"]
	var diff := close - open
	var color := COLOR_GREEN if diff > 0 else COLOR_RED
	price.text = "%.2f$" % [close]
	change_price.text = "%.2f$" % [diff]
	change_percent.text = "%.2f%%" % [100 * diff / open]
	change_price.add_theme_color_override("font_color", color)
	change_percent.add_theme_color_override("font_color", color)
