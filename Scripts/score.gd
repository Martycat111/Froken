extends RichTextLabel


@onready var anim = get_node("ScoreAnim")

var last = "0"

func _process(_delta: float) -> void:
	if last != str(Global.score):
		self.set_text(" " + str(Global.score))
		anim.play("Add")
	last = str(Global.score)
