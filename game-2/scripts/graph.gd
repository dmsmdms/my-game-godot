extends Control

func _draw() -> void:
	var krect = self.get_meta("krect")
	for r in krect:
		draw_rect(r["k"], Color("#4c4c4c"))
		draw_rect(r["p"], r["c"])
