extends Sprite2D

func _process(delta: float) -> void:
	position.y = 0
	position.x -= float((300 + Global.speedup)) / 1.5 * delta
	if position.x > 2700:
		queue_free()
