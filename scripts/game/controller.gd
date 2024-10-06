extends Node2D

var pos_input : Vector2 = Vector2.UP
var current_strand : Line2D
var moving = false
var path : PathFollow2D
var curve : Curve2D
var speed : float
var strands : Array[Line2D]
var bugs : Array[Node2D]
var is_sprinting : bool = false
var navigation_node : Area2D
@export var web_strand : PackedScene
@export var web : Node2D
@export var intersections : Node2D
@export var starting_strand : Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Path follow assignment
	path = get_parent()
	curve = path.get_parent().curve
	speed = GameManager.move
	GameManager.intersections = intersections
	GameManager.web = web
	StartCurve()
	current_strand = starting_strand
	current_strand.broken.connect(SafePlace)

func _physics_process(delta: float) -> void:
	if !GameManager.is_ended:
		GameManager.Hunger(-delta * GameManager.hunger_drain_rate)
		GameManager.Stamina(delta * GameManager.stamina_regen)
		
		if strands.size() > 0:
			for i in strands:
				i.Firing()
		
		if bugs.size() > 0:
			for i in bugs:
				i.Damage(delta * GameManager.damage)
		
		var movement_vector = Vector2(Input.get_axis("Move Left", "Move Right"), Input.get_axis("Move Up", "Move Down"))
		
		if is_sprinting:
			if GameManager.stamina > GameManager.stamina_sprint_cost:
				GameManager.Stamina(-delta * GameManager.stamina_sprint_cost)
				speed = GameManager.sprint
			else:
				speed = GameManager.move
				
		#position += movement_vector * speed * GameManager.speed_mod
		
		# Path follow movement-ish
		if path:
			if movement_vector == pos_input:
				path.progress += speed
			elif movement_vector == -pos_input:
				path.progress -= speed
		#if path:
			#if movement_vector.x > 0 or movement_vector.y < 0:
				#path.progress += speed
			#elif movement_vector.x < 0 or movement_vector.y > 0:
				#path.progress -= speed

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Sprint"):
		speed = GameManager.sprint
		is_sprinting = true
		
	if event.is_action_released("Sprint"):
		speed = GameManager.move
		is_sprinting = false
		
	if event.is_action_released("Fire"):
		ShotWeb(get_global_mouse_position())
	
	if event.is_action_pressed("Cheat Level"):
		GameManager.XP(GameManager.level_threshold)
	
	if navigation_node:
		if event.is_action_pressed("Move Up"):
			if navigation_node.nav_up:
				ChangeCurrentStrand(navigation_node.nav_up.strand)
				SetNewCurve(navigation_node.nav_up.target)
				pos_input = Vector2.UP
				#print("Go up: %s" % pos_input)
			
		if event.is_action_pressed("Move Down"):
			if navigation_node.nav_down:
				ChangeCurrentStrand(navigation_node.nav_down.strand)
				SetNewCurve(navigation_node.nav_down.target)
				pos_input = Vector2.DOWN
				#print("Go down: %s" % pos_input)
			
		if event.is_action_pressed("Move Left"):
			if navigation_node.nav_left:
				ChangeCurrentStrand(navigation_node.nav_left.strand)
				SetNewCurve(navigation_node.nav_left.target)
				pos_input = Vector2.LEFT
				#print("Go left: %s" % pos_input)
			
		if event.is_action_pressed("Move Right"):
			if navigation_node.nav_right:
				ChangeCurrentStrand(navigation_node.nav_right.strand)
				SetNewCurve(navigation_node.nav_right.target)
				pos_input = Vector2.RIGHT
				#print("Go right: %s" % pos_input)
		

func ShotWeb(target : Vector2):
	if GameManager.stamina > GameManager.stamina_shot_cost:
		GameManager.Stamina(-GameManager.stamina_shot_cost)
		var direction = target - global_position
		var new_strand = GameManager.strand.instantiate()
		web.add_child(new_strand, true)
		#print("Drawing line from %s to %s" % [global_position, target])
		new_strand.Initialize(global_position, direction)
		strands.append(new_strand)
		new_strand.completed_firing.connect(EndStrand)
		new_strand.node_a.CreateIntersect(current_strand)
	
	else:
		# Do error feedback here
		print("Cannot shot web")

func EndStrand(element : Line2D):
	strands.erase(element)

func on_area_entered(area : Area2D):
	if area.has_meta("type"):
		if area.get_meta("type") == "bug":
			bugs.append(area.get_parent())

func on_area_exited(area : Area2D):
		if area.has_meta("type"):
			if area.get_meta("type") == "bug":
				var new_bug = area.get_parent()
				if bugs.has(new_bug):
					bugs.erase(new_bug)

func on_nav_entered(area : Area2D):
	navigation_node = area
	print("Navigation located")

func on_nav_exited(area : Area2D):
	if navigation_node == area:
		navigation_node = null

func StartCurve():
	var new_curve : Curve2D = curve
	new_curve.clear_points()
	new_curve.add_point(starting_strand.node_a.global_position, Vector2.ZERO, Vector2.ZERO)
	new_curve.add_point(starting_strand.node_b.global_position, Vector2.ZERO, Vector2.ZERO)
	curve = new_curve
	path.progress = 0

func SetNewCurve(target : Vector2):
	var new_curve : Curve2D = curve
	new_curve.clear_points()
	new_curve.add_point(navigation_node.global_position, Vector2.ZERO, Vector2.ZERO)
	new_curve.add_point(target, Vector2.ZERO, Vector2.ZERO)
	curve = new_curve
	path.progress = 0
	#pos_input = position.direction_to(target)
	#print("Direction to target on path %s" % pos_input)

func ChangeCurrentStrand(new_strand : Line2D):
	if is_instance_valid(current_strand):
		current_strand.broken.disconnect(SafePlace)
	current_strand = new_strand
	current_strand.broken.connect(SafePlace)

func SafePlace():
	current_strand.broken.disconnect(SafePlace)
	var stored = path.progress_ratio
	path.progress_ratio = roundf(path.progress_ratio)
	print("Moving to safety from %s to %s" % [stored, path.progress_ratio])
	curve.clear_points()
