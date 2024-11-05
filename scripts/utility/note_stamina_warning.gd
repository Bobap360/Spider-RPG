extends Label

var anim : Tween

func _ready() -> void:
	pass
	
func notify():
	if anim:
		anim.stop()
		
	visible = true
	anim = create_tween()
	anim.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15)
	anim.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)
	anim.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await anim.finished
	visible = false
