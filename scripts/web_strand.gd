extends Line2D

var node_a : Node2D
var node_b : Node2D
@export var web_area : Area2D
@export var collider : CollisionShape2D
@export var thickness : float = 10.0
@export var glob : Node2D
@export var debug_label : Label
var target : Vector2
#var can_stop : bool = false
var bugs : Array[Node2D]

signal completed_firing(element : Line2D)
signal broken()

func _ready() -> void:
	debug_label.text = str(self.name)

# Fills variables required to operate
func Initialize(start : Vector2, new_target : Vector2, existing_nav : Node2D) -> void:
	#node_a.position = start
	#node_b.position = start
	if existing_nav:
		node_a = existing_nav
	else:
		node_a = CreateNav(start)
	node_b = CreateNav(start)
	node_a.strands.append(self)
	node_b.strands.append(self)
	target = new_target.normalized()
	collider.shape = RectangleShape2D.new()


# Grows the strand
func Firing():
	#node_b.position = node_b.position.move_toward(target, GameManager.web_speed)
	# Animates the motion of the web strand
	node_b.position += target * GameManager.web_speed
	glob.position = node_b.position
	set_points(PackedVector2Array([node_a.position, node_b.position]))
	
	# Scales the collider for the strand
	UpdateCollider()
	
	# End function for move_toward implementation
	#if node_b.position.distance_to(target) < 0.1:
		#completed_firing.emit(self)

func End(source : Line2D):
	#can_stop = true
	#call_deferred("CreateNav", node_b.position)
	node_a.set_deferred("monitorable", true)
	node_b.set_deferred("monitorable", true)
	node_a.UpdateDirections()
	node_b.call_deferred("CreateIntersect", source)
	completed_firing.emit(self)
	
	if is_instance_valid(glob):
		glob.queue_free()

# Sizes the collider to match the path
func UpdateCollider():
	var a = node_a.position
	var b = node_b.position
	collider.shape.size = Vector2(absf(a.distance_to(b)), thickness)
	collider.global_rotation = a.angle_to_point(b)
	collider.global_position = a + (b - a) * 0.5

func Vanish():
	# Breaking animation stuff goes here
	node_a.Remove(self)
	node_b.Remove(self)
	queue_free()

func Break():
	for i in bugs:
		i.FlyAway()
	# Breaking animation stuff goes here
	node_a.Remove(self)
	node_b.Remove(self)
	if GameManager.controller.GetCurrentStrand() == self:
		GameManager.controller.SafePlace()
	queue_free()

func CreateNav(new_pos : Vector2) -> Node2D:
	print("Creating New Nav Node")
	var new_nav = GameManager.nav_node.instantiate()
	GameManager.intersections.add_child(new_nav, true)
	new_nav.position = new_pos
	return new_nav

func AdjustPlacement(new_a : Node2D, new_b : Node2D):
	node_a = new_a
	node_b = new_b
	set_points(PackedVector2Array([node_a.position, node_b.position]))
	UpdateCollider()
	node_a.strands.append(self)
	node_b.strands.append(self)
	node_a.UpdateDirections()
	node_b.UpdateDirections()

func ReassignBugs():
	if bugs.size() > 0:
		#print("Reassigning bugs")
		
		var list : Array[Node2D]
		list.assign(bugs)
		bugs.clear()
		
		for i in list:
			#print("Checking")
			i.CheckWeb()
