extends Area2D

const SHOOT_TIME := 1.0

@onready var player_rect: Panel = $"../Player/ColorRect"

var shoot_time := -1.0
var target: Area2D = null
var targets := []

func _process(delta: float) -> void:
	if shoot_time > SHOOT_TIME or (target and target.global_position.x - global_position.x < 0.1):
		target = targets.pop_front()
		global_position = player_rect.global_position
		if target:
			shoot_time = 0.0
		else:
			shoot_time = -1.0
			visible = false

	if shoot_time >= 0:
		global_position += (shoot_time / SHOOT_TIME) * (target.global_position - global_position) 
		shoot_time += delta

func _on_enemy_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		var sprite: Sprite2D = area.get_node("Sprite2D")
		if sprite.visible:
			if not visible:
				global_position = player_rect.global_position
				visible = true
				target = area
				shoot_time = 0.0
			else:
				targets.push_back(area)
