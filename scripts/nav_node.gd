extends Area2D

@export var nav_up : NavInfo 
@export var nav_down : NavInfo 
@export var nav_left : NavInfo 
@export var nav_right : NavInfo 
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
	new_strand.glob.queue_free()
	new_strand.AdjustPlacement(self, b)
	
	strands.append(new_strand)
	strands.append(strand)
	
	strand.ReassignBugs()
	
	SetNav()

func Remove(element : Line2D):
	strands.erase(element)
	
	if nav_up:
		if nav_up.strand == element:
			#print("Fixing Nav")
			nav_up = null
	if nav_down:
		if nav_down.strand == element:
			#print("Fixing Nav")
			nav_down = null
	if nav_left:
		if nav_left.strand == element:
			#print("Fixing Nav")
			nav_left = null
	if nav_right:
		if nav_right.strand == element:
			#print("Fixing Nav")
			nav_right = null
	
	if strands.size() == 2:
		MergeToSingle()
	
	if strands.size() <= 0:
		print("No Connections")
		queue_free()

#func ValidateNav(element : Line2D, nav : NavInfo):
	#if nav:
		#if nav.strand == element:
			#print("Fixing Nav")
			#nav = null
#
#func ValidateStrands():
	#if !is_instance_valid(nav_up.strand):
		#nav_up = null
	#if !is_instance_valid(nav_down.strand):
		#nav_down = null
	#if !is_instance_valid(nav_left.strand):
		#nav_left = null
	#if !is_instance_valid(nav_right.strand):
		#nav_right = null

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
	print("Checking on %s connected to %s and %s" % [self, a, b])
	if InLine(a, b):
		strands[1].bugs.append_array(strands[0].bugs)
		for i in strands[0].bugs:
			i.strand = strands[1]
		
		strands[1].AdjustPlacement(a, b)
		strands[0].Vanish()
		print("Deleting %s" % self)
		queue_free()
	#print("Direction 1 is %s and direction 2 is %s" % [v1, v2])
	#print("Difference is %s" % diff)
	
	# Cross Product Attempt
	#if InLine(a, self, b):
		#print("Straight Line")
	#else:
		#print("Curved Line")
	
	# Vector Difference Attempt
	#var dif : Vector2 = (a.global_position - global_position) - (global_position - b.global_position)
	#dif = Vector2(abs(dif.x), abs(dif.y))
	#print("Difference is %s" % dif)
	#if dif.x < dif.y:
		#if dif.x < .0:
			#print("The line is horizontal")
			#return
	#else:
		#if dif.y < 1.0:
			#print("The line is vertical")
			#return
	#print("The line curves")
	
	#strands[1].bugs.append_array(strands[0].bugs)
	#for i in strands[0].bugs:
		#i.strand = strands[1]
	#
	#strands[1].AdjustPlacement(a, b)
	#strands[0].Vanish()
	#queue_free()

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
				nav_right = NavInfo.new()
				nav_right.target = target.global_position
				nav_right.strand = i
			else:
				nav_left = NavInfo.new()
				nav_left.target = target.global_position
				nav_left.strand = i
		else:
			# Is vertical
			if direction.y < 0:
				nav_up = NavInfo.new()
				nav_up.target = target.global_position
				nav_up.strand = i
			else:
				nav_down = NavInfo.new()
				nav_down.target = target.global_position
				nav_down.strand = i
