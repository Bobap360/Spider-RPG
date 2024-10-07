extends Area2D

@export var debug_label : Label
@export var strands : Array[Node2D]
var directions : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_label.text = self.name

func CreateIntersect(strand : Line2D):
	var a = strand.node_a
	var b = strand.node_b
	
	a.strands.erase(strand)
	b.strands.erase(strand)
	
	strand.AdjustPlacement(self, a)
	
	#print("Creating a new intersection between %s and %s" % [a, b])
	print("Checking on %s" % strand.name)
	if strand.get_meta("type") == "post":
		var new_post = GameManager.NewPost()
		new_post.collider.shape = RectangleShape2D.new()
		new_post.AdjustPlacement(self, b)
	else:
		var new_strand = GameManager.NewStrand()
		new_strand.collider.shape = RectangleShape2D.new()
		new_strand.glob.queue_free()
		new_strand.AdjustPlacement(self, b)
	
	strand.ReassignBugs()

func Remove(element : Line2D):
	strands.erase(element)
	
	if strands.size() == 2:
		MergeToSingle()
	
	if strands.size() <= 0:
		print("No Connections")
		queue_free()
	
	UpdateDirections()

# Turns straight line intersections into a continuous line
func MergeToSingle():
	var a : Node2D
	var b : Node2D
	
	if strands[0].node_a != self:
		a = strands[0].node_a
	else:
		a = strands[0].node_b
	
	if strands[1].node_a != self:
		b = strands[1].node_a
	else:
		b = strands[1].node_b
		
	#print("Checking on %s connected to %s and %s" % [self, a, b])
	if InLine(a, b):
		strands[1].bugs.append_array(strands[0].bugs)
		for i in strands[0].bugs:
			i.strand = strands[1]
		
		strands[1].AdjustPlacement(a, b)
		strands[0].Vanish()
		#print("Deleting %s" % self)
		queue_free()

# Returns whether the three nodes are in a straight line together
func InLine(a : Node2D, b: Node2D) -> bool:
	# Direction To Attempt
	var v1 = a.global_position.direction_to(global_position)
	var v2 = global_position.direction_to(b.global_position)
	var dif = v1 - v2
	dif = abs(dif)
	
	#print ("%s differs by %s" % [self, dif])
	if dif.x < 0.05 and dif.y < 0.05:
		print("%s is a STRAIGHT LINE" % self.name)
		return true
	else:
		print("%s is a CURVY BITCH" % self.name)
		return false
		
func SendDirection(input_dir : Vector2, start : Vector2) -> Vector2:
	if directions.size() > 0:
		var choice : Vector2 = directions[0]
		var closest : float = 1000
		
		for i in directions:
			#print("Inputting %s and comparing to %s" % [input_dir, start.direction_to(i)])
			var v1 = input_dir - start.direction_to(i)
			var dif = abs(v1.x) + abs(v1.y)
			#print("Comparator value of %s" % abs(dif))
			if dif < closest:
				closest = dif
				choice = i
		#print("Telling player to go toward %s" % choice)
		#print(" ")
		return choice
	else:
		printerr("No directions to go")
		return Vector2.ZERO

func UpdateDirections():
	directions.clear()
	for i in strands:
		print("Updating directions with %s data" % i.name)
		if i.node_a != self:
			directions.append(i.node_a.global_position)
		else:
			directions.append(i.node_b.global_position)
