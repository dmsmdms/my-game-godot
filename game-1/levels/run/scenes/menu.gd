extends Control

@onready var tree := get_tree()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_input_paused() -> void:
	if visible:
		_on_restore_pressed()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		tree.paused = true
		visible = true

func _on_restore_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	tree.paused = false
	visible = false

func _on_restart_pressed() -> void:
	tree.reload_current_scene()
	_on_restore_pressed()

func _on_exit_pressed() -> void:
	tree.quit()
