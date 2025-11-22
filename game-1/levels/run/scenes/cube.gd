extends Node3D

@onready var red: MeshInstance3D = $Model/Red
@onready var green: MeshInstance3D = $Model/Green

var move_direction: float = 0.0

func _ready() -> void:
	_on_timer_timeout()

func _process(delta: float) -> void:
	position.y += move_direction * delta

func _on_timer_timeout() -> void:
	move_direction = randf() - 0.5
	green.visible = true if move_direction > 0 else false
	red.visible = true if move_direction <= 0 else false

func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("player"):
		pass
		# var diff := area.global_transform.origin - global_transform.origin
		# var abs_diff := abs(diff)
		# if abs_diff.x > abs_diff.z:
			# abs_diff
			
		# print(diff)
