extends Label


func _process(delta: float) -> void:
	position.y = 0
	position.x -= 300 * delta
	if position.x < -2700:
		queue_free()
