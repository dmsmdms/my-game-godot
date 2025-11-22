extends Node3D

const CUBE := preload("res://levels/run/scenes/cube.tscn")

func _ready() -> void:
	for z in range(10):
		for x in range(10):
			var cube = CUBE.instantiate()
			cube.position.z = (z - 5) * 3
			cube.position.x = (x - 5) * 3
			cube.position.y = -2
			add_child(cube)
