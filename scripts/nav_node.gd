extends Area2D

var nav_up : NavInfo = NavInfo.new()
var nav_down : NavInfo = NavInfo.new()
var nav_left : NavInfo = NavInfo.new()
var nav_right : NavInfo = NavInfo.new()
@export var debug_label : Label
@export var strands : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	debug_label.text = self.name

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
	
	a.strands.erase(strand)
	b.strands.erase(strand)
	
	strand.AdjustPlacement(self, a)
	
	print("Creating a new intersection between %s and %s" % [a, b])
	
	var new_strand = GameManager.NewStrand()
	new_strand.collider.shape = RectangleShape2D.new()
	new_strand.glob.queue_free()
	new_strand.AdjustPlacement(self, b)

	#strands.append(new_strand)
	#strands.append(strand)
	
	strand.ReassignBugs()
	#
	#SetNav()

func Remove(element : Line2D):
	strands.erase(element)
	
	## Clears freed instances
	#if nav_up:
		#if nav_up.strand == element:
			##print("Fixing Nav")
			#nav_up = null
	#if nav_down:
		#if nav_down.strand == element:
			##print("Fixing Nav")
			#nav_down = null
	#if nav_left:
		#if nav_left.strand == element:
			##print("Fixing Nav")
			#nav_left = null
	#if nav_right:
		#if nav_right.strand == element:
			##print("Fixing Nav")
			#nav_right = null
	
	if strands.size() == 2:
		MergeToSingle()
	
	if strands.size() <= 0:
		print("No Connections")
		queue_free()
	
	SetNav()

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
	
	print ("%s differs by %s" % [self, dif])
	if dif.x < 0.05 and dif.y < 0.05:
		print("STRAIGHT LINE")
		return true
	else:
		print("CURVY BITCH")
		return false
		

func SetNav():
	#print("Setting nav on %s" % self.name)
	nav_right = NavInfo.new()
	nav_left = NavInfo.new()
	nav_up = NavInfo.new()
	nav_down = NavInfo.new()
	
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
				nav_right.target = target.global_position
				nav_right.strand = i
			else:
				nav_left.target = target.global_position
				nav_left.strand = i
		else:
			# Is vertical
			if direction.y < 0:
				nav_up.target = target.global_position
				nav_up.strand = i
			else:
				nav_down.target = target.global_position
				nav_down.strand = i
