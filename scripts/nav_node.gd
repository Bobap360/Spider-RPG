extends Area2D

@export var nav_up : Vector2
@export var nav_down : Vector2
@export var nav_left : Vector2
@export var nav_right : Vector2
var strands : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func CheckIntersects():
	var intersects = get_overlapping_areas()
	
	for i in intersects:
		if i.has_meta("type"):
			if i.get_meta("type") == "web":
				strands.append(i.get_parent())
	
	SetNav()

func CreateIntersect(strand : Line2D):
	var a = strand.node_a
	var b = strand.node_b
	strand.AdjustPlacement(self, a)
	
	var new_strand = GameManager.NewStrand()
	new_strand.collider.shape = RectangleShape2D.new()
	new_strand.AdjustPlacement(self, b)

func Remove(element : Line2D):
	strands.erase(element)
	if strands.size() <= 0:
		queue_free()

func SetNav():
	for i in strands:
		var target : Node2D
		if i.node_a != self:
			target = i.node_a
		else:
			target = i.node_b
		
		var direction = global_position.direction_to(target.global_position)
		var x = absf(direction.x)
		var y = absf(direction.y)
		
		if x > y:
			# Is horizontal
			if direction.x > 0:
				nav_right = target.global_position
			else:
				nav_left = target.global_position
		else:
			# Is vertical
			if direction.y < 0:
				nav_up = target.global_position
			else:
				nav_down = target.global_position
