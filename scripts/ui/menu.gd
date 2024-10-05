extends Control

@export var fade : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(get_viewport().size.x/2, -1000)
	fade.self_modulate = Color(1,1,1,0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		if GameManager.is_paused:
			Hide()
		else:
			Show()

func Show():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(get_viewport().size.x/2, get_viewport().size.y/2), 0.3)
	tween.parallel().tween_property(fade, "self_modulate", Color(1, 1, 1, 1), 0.3)
	GameManager.Pause()
	
func Hide():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(get_viewport().size.x/2, -1000), 0.3)
	tween.parallel().tween_property(fade, "self_modulate", Color(1, 1, 1, 0), 0.3)
	GameManager.Resume()

func Quit():
	GameManager.Quit()
