extends Node2D

class_name Tools

static func fade_in(obj : Node):
	var tween = obj.create_tween().bind_node(obj)
	tween.tween_property(obj, "modulate", Color(1, 1, 1, 1), 0.15)
	tween.tween_property(obj, "modulate", Color(1, 1, 1, 1), 0.5)
	tween.tween_property(obj, "modulate", Color(1, 1, 1, 0), 0.15)
