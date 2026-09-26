extends RigidBody2D

@onready var Player = get_node("../../Player")

var playerison = false

func _process(delta: float) -> void:
	position.y = 0
	position.x -= (300 + Global.speedup) * delta
	if position.x < -2600:
		queue_free()


func _on_is_on_ice_body_entered(body: Node2D) -> void:
	if !(body.name == "Player"):
		return
	if body.velocity[1] > 100:
		print(body.velocity[1])
		Global.speedup += 20
