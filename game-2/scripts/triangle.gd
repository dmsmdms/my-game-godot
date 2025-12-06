extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: CPUParticles2D = $CPUParticles2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet") and sprite.visible:
		particles.emitting = true
		sprite.visible = false
