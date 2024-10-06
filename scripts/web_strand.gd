extends Line2D

@export var node_a : Area2D
@export var node_b : Area2D
@export var collider : CollisionShape2D
@export var thickness : float = 10.0
@export var glob : Node2D
var target : Vector2
var can_stop : bool = true
var bugs : Array[Node2D]

signal completed_firing(element : Line2D)

# Fills variables required to operate
func Initialize(start : Vector2, new_target : Vector2) -> void:
	node_a.position = start
	node_b.position = start
	target = new_target.normalized()
	collider.shape = RectangleShape2D.new()

# Grows the strand
func Firing():
	#node_b.position = node_b.position.move_toward(target, GameManager.web_speed)
	# Animates the motion of the web strand
	node_b.position += target * GameManager.web_speed
	set_points(PackedVector2Array([node_a.position, node_b.position]))
	
	# Scales the collider for the strand
	UpdateCollider()
	
	# End function for move_toward implementation
	#if node_b.position.distance_to(target) < 0.1:
		#completed_firing.emit(self)

func End():
	glob.queue_free()
	completed_firing.emit(self)

# Sizes the collider to match the path
func UpdateCollider():
	var a = node_a.position
	var b = node_b.position
	collider.shape.size = Vector2(absf(a.distance_to(b)), thickness)
	collider.global_rotation = a.angle_to_point(b)
	collider.global_position = a + (b - a) * 0.5

func Break():
	for i in bugs:
		i.FlyAway()
	# Breaking animation stuff goes here
	queue_free()

func on_area_entered(area : Area2D):
	if area.has_meta("type"):
		# Checks against self collision and valid "Stop" objects
		if area.get_meta("type") == "web" and area != node_b and can_stop:
			area.get_parent().End()
			
		# Disables self collision
		if area.get_meta("type") == "player":
			can_stop = false

func on_area_exited(area : Area2D):
		if area.has_meta("type"):
			# Re-enables the strand stopping collision
			if area.get_meta("type") == "player":
				can_stop = true
