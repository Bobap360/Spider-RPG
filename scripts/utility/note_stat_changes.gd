extends Label

var anim : Tween

func _ready() -> void:
	GameManager.xp_changed.connect(notify_xp)

func notify_xp(amount : int):
	if anim:
		anim.stop()
		
	visible = true
	text = "+%sxp" % amount
	anim = create_tween()
	anim.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	anim.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.5)
	anim.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await anim.finished
	visible = false
