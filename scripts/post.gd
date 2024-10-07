extends Line2D

@export var node_a : Node2D
@export var node_b : Node2D
@export var collider : CollisionShape2D
@export var thickness : float = 10
@export var debug_label : Label
var bugs : Array[Node2D] = []
var can_stop : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#global_position = Vector2.ZERO
	#print("From %s to %s" % [node_a.global_position, node_b.global_position])
	set_points(PackedVector2Array([node_a.global_position, node_b.global_position]))
	node_a.strands.append(self)
	node_b.strands.append(self)
	print("Adding %s to %s and %s" % [self.name, node_a.name, node_b.name])
	debug_label.text = str(self.name)
	
	collider.shape = RectangleShape2D.new()
	UpdateCollider()
	node_a.UpdateDirections()
	node_b.UpdateDirections()

# Sizes the collider to match the path
func UpdateCollider() -> void:
	var a = node_a.position
	var b = node_b.position
	collider.shape.size = Vector2(absf(a.distance_to(b)), thickness)
	collider.global_rotation = a.angle_to_point(b)
	collider.global_position = a + (b - a) * 0.5

func AdjustPlacement(new_a : Node2D, new_b : Node2D):
	node_a = new_a
	node_b = new_b
	set_points(PackedVector2Array([node_a.position, node_b.position]))
	UpdateCollider()
	node_a.strands.append(self)
	node_b.strands.append(self)

func Vanish():
	# Breaking animation stuff goes here
	node_a.Remove(self)
	node_b.Remove(self)
	queue_free()

func ReassignBugs():
	pass
