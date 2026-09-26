extends Area2D

@onready var Player = get_node("../../Player")

func _process(delta: float) -> void:
	position.x -= (300 + Global.speedup) * delta
	if position.x < -1900:
		queue_free()


func _on_body_entered(body) -> void:
	Player.hitmove()
