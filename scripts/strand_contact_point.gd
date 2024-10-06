extends Area2D

@export var collider : CollisionShape2D
@export var strand : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	collider.disabled = false

func _on_area_entered(area: Area2D) -> void:
		if area.has_meta("type"):
			# Checks against self collision and valid "Stop" objects
			if area.get_meta("type") == "web" and area != strand.web_area:
				print("Firing End")
				strand.End(area.get_parent())
				queue_free()
