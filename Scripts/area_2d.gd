extends Area2D


@onready var Player = get_node("../../Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= (300 + Global.speedup) * delta
	if position.x < -1900:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	Player.hitspin()
