extends RichTextLabel


var last = "0"
var texti

func _process(_delta: float) -> void:
	texti = str(Global.jumpsleft)
	if last != texti:
		self.set_text(" " + texti)
	last = texti
