extends Button

@onready var settingsmenu = get_node("../../Settingsmenu")

func _on_pressed() -> void:
	settingsmenu.show()


func _on_back_button_pressed() -> void:
	settingsmenu.hide()
