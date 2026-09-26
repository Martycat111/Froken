extends RigidBody2D

@onready var Player = get_node("../../Player")

var playerison = false

func _process(delta: float) -> void:
	position.y = 0
	position.x -= (300 + Global.speedup) * delta
	if position.x < -2100:
		queue_free()


func _on_is_on_ice_body_entered(_body: Node2D) -> void:
	Global.speedup += 2
