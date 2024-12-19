extends Area2D

var overlaps : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	overlaps = get_overlapping_areas()
