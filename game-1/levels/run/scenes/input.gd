extends Control

signal paused

func _input(event: InputEvent) -> void:
	if event is InputEventKey: 
		if event.is_action_pressed("pause"):
			paused.emit()

func _on_pause_pressed() -> void:
	paused.emit()
