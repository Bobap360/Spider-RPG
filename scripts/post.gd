extends Line2D

@export var node_a : Node2D
@export var node_b : Node2D
@export var collider : CollisionShape2D
@export var thickness : float = 10
var can_stop : bool = true
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	global_position = Vector2.ZERO
	set_points(PackedVector2Array([node_a.global_position, node_b.global_position]))
	UpdateCollider()

# Sizes the collider to match the path
func UpdateCollider() -> void:
	var a = node_a.position
	var b = node_b.position
	collider.shape.size = Vector2(absf(a.distance_to(b)), thickness)
	collider.global_rotation = a.angle_to_point(b)
	collider.global_position = a + (b - a) * 0.5

func AreaEntered(area : Area2D) -> void:
	pass
	#if area.has_meta("type"):
		## Catches the web strands that hit it
		#if can_stop and area.get_meta("type") == "web" and !area.get_parent().can_stop:
			#area.get_parent().End(self)
		#
		## Disables self collisions
		#if area.get_meta("type") == "player":
			#can_stop = false

func AreaExited(area : Area2D) -> void:
	#if area.has_meta("type"):
		## Re-enables the web collision
		#if area.get_meta("type") == "player":
			#can_stop = true
	pass

func AdjustPlacement(new_a : Node2D, new_b : Node2D):
	node_a = new_a
	node_b = new_b
	set_points(PackedVector2Array([node_a.position, node_b.position]))
	UpdateCollider()
