extends RigidBody2D

@onready var Player = get_node("../../Player")

var playerison = false

func _process(delta: float) -> void:
	position.y = 0
	position.x -= (300 + Global.speedup) * delta
	if position.x < -2700:
		queue_free()


func _on_is_on_ice_body_entered(body: Node2D) -> void:
	if !(body.name == "Player"):
		return
	Global.speedup += 10


func _on_body_entered(_body: Node) -> void:
	Global.speedup += 50


func _on_body_exited(_body: Node) -> void:
	Global.speedup -= 30
