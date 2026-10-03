extends Button

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("play"):
		self.emit_signal("pressed")
