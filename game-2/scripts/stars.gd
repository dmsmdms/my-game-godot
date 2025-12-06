extends Control

func _draw() -> void:
	for i in range(200):
		var pos := Vector2(randf() * size.x, randf() * size.y)
		var brightness := randf_range(0.5, 1.0)
		var radius := randf_range(1.0, 2.5)
		draw_circle(pos, radius, Color(1, 1, 1, brightness))
