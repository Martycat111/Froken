extends AnimationPlayer



var gamescene = preload("res://scenes/game.tscn").instantiate()

func _ready() -> void:
	self.play("load")


func _on_play_button_pressed() -> void:
	get_tree().root.add_child(gamescene) #add the game scene to the tree
	get_tree().root.get_node("Title").free() #remove the titlescreen
