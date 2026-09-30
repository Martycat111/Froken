extends AnimationPlayer



var gamescene = preload("res://scenes/game.tscn").instantiate()

func _ready() -> void:
	self.play("load")


func _on_play_button_pressed() -> void:
	self.play("fadeout")
	await self.animation_finished
	get_tree().root.add_child(gamescene) #add the game scene to the tree
	get_tree().root.get_node("Title").queue_free() #remove the titlescreen
