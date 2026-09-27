extends Sprite2D

@onready var Player = get_node("../../Player")

func _process(delta: float) -> void:
	position.x -= (300 + Global.speedup) * delta
	if position.x < -2700:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Player.hitmove()
