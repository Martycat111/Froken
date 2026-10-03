extends RichTextLabel


@onready var anim = get_node("ScoreAnim")

var last = "0"
var texti

func _process(_delta: float) -> void:
	texti = str(round(Global.speedup - Global.tempspeedupamount)).replace(".0", "")
	if last != texti and int(texti) > int(last):
		self.set_text(" " + texti)
		anim.play("Add")
	last = texti
