extends Area2D

@export var controller : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_area_entered(area : Area2D):
	if area.has_meta("type"):
		if area.get_meta("type") == "nav":
			var new_curve : Curve2D = controller.curve
			new_curve.clear_points()
			new_curve.add_point(area.global_position, Vector2.ZERO, Vector2.ZERO)
			new_curve.add_point(area.target_node.global_position, Vector2.ZERO, Vector2.ZERO)
			controller.curve = new_curve
			controller.path.progress = 0
			#print("Entered cross to %s" % area.target_node)
	
