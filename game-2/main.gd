extends Node2D

const PLATORM := preload("res://platform.tscn")
const MIN_DIST := Vector2(0.0, 150.0)
const MAX_DIST := Vector2(400.0, 500.0)
const INIT_PLATFORM_COUNT := 10

@onready var view_size := get_viewport_rect().size
@onready var start_platform: StaticBody2D = $Platform
@onready var last_spawn_pos := start_platform.position

func _on_screen_exit() -> void:
	add_platform()

func add_platform() -> void:
	var platform := PLATORM.instantiate()
	var notifier: VisibleOnScreenNotifier2D = platform.get_node("ScreenNotifier")
	notifier.screen_exited.connect(_on_screen_exit)
	
	var x_dir: float = [-1.0, 1.0].pick_random()
	last_spawn_pos.x -= x_dir * randf_range(MIN_DIST.x, MAX_DIST.x)
	last_spawn_pos.y -= randf_range(MIN_DIST.y, MAX_DIST.y)
	platform.position = last_spawn_pos
	add_child(platform)

func _ready() -> void:
	for i in range(INIT_PLATFORM_COUNT):
		add_platform()
