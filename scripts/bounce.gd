extends Node2D

@export var rate : float = 0.3
@export var min_scale : float = 0.9
@export var max_scale : float = 1.1
var bouncing = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Bounce()

func Bounce() -> void:
	if bouncing:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(min_scale, min_scale), rate)
		tween.tween_property(self, "scale", Vector2(max_scale, max_scale), rate)
		await tween.finished
		Bounce()
