extends Area2D

var can_stop : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func AreaEntered(area : Area2D):
	if area.has_meta("type"):
		# Catches the web strands that hit it
		if area.get_meta("type") == "web" and can_stop:
			area.get_parent().End()
		
		# Disables self collisions
		if area.get_meta("type") == "player":
			can_stop = false

func AreaExited(area : Area2D):
		if area.has_meta("type"):
			# Re-enables the web collision
			if area.get_meta("type") == "player":
				can_stop = true
