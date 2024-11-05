extends Control

var anim : Tween

func _ready() -> void:
	GameManager.leveled_up.connect(notify)

func notify():
	if anim:
		anim.stop()
		
	visible = true
	anim = create_tween()
	anim.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)
	anim.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.5)
	anim.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.15)
	await anim.finished
	visible = false
