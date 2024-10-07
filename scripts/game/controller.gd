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
@export var nav_controller : Area2D
@export var joystick_target : Node2D
@export var anim : AnimatedSprite2D
var joystick_web_lock : bool = false
var target_location : Vector2
var start_location : Vector2
var lock_movement : bool = false
var is_attacking : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = GameManager.move
	GameManager.intersections = intersections
	GameManager.web = web
	GameManager.controller = self
	current_strand = starting_strand

func _physics_process(delta: float) -> void:
	if !GameManager.is_ended:
		GameManager.Hunger(-delta * GameManager.hunger_drain_rate)
		GameManager.Stamina(delta * GameManager.stamina_regen)
		
		if strands.size() > 0:
			for i in strands:
				i.Firing()
		
		if bugs.size() > 0:
			is_attacking = true
			anim.play("attack")
			for i in bugs:
				i.Damage(delta * GameManager.damage)
		else:
			is_attacking = false
		
		if !lock_movement:
			var movement_vector = Vector2(Input.get_axis("Move Left", "Move Right"), Input.get_axis("Move Up", "Move Down"))
			
			var targeting_vector = Vector2(Input.get_axis("Target Left", "Target Right"), Input.get_axis("Target Up", "Target Down"))
			if abs(targeting_vector.x) > 0.2 or abs(targeting_vector.y) > 0.2:
				joystick_target.position = targeting_vector * 75
				joystick_target.visible = true
			else:
				joystick_target.visible = false
			
			if is_sprinting:
				if GameManager.stamina > GameManager.stamina_sprint_cost:
					GameManager.Stamina(-delta * GameManager.stamina_sprint_cost)
					speed = GameManager.sprint
				else:
					speed = GameManager.move
			
			if movement_vector != Vector2.ZERO:
				if MovingToward(movement_vector, target_location):
					global_position = global_position.move_toward(target_location, speed)
					anim.look_at(target_location)
					anim.play("move")
				elif MovingToward(movement_vector, start_location):
					global_position = global_position.move_toward(start_location, speed)
					anim.look_at(start_location)
					anim.play("move")
				else:
					if !is_attacking:
						anim.stop()
				
				if navigation_node:
					var new_direction = navigation_node.SendDirection(movement_vector, global_position)
					if new_direction != Vector2.ZERO and new_direction != target_location:
						start_location = navigation_node.global_position
						target_location = new_direction
						#global_position = navigation_node.global_position
						#print("Updating direction to %s" % target_location)
			else:
				if !is_attacking:
					anim.stop()
			#position += movement_vector * speed * GameManager.speed_mod
		

func MovingToward(move_dir : Vector2, target : Vector2) -> bool:
	var dif = move_dir - global_position.direction_to(target)
	#print("Input offset is %s" % (abs(dif.x) + abs(dif.y)))
	if abs(dif.x) + abs(dif.y) < 1.0:
		return true
	else:
		return false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Game Over"):
		GameManager.End()
		
	if !GameManager.is_ended:
		if event.is_action_pressed("Sprint"):
			speed = GameManager.sprint
			is_sprinting = true
			
		if event.is_action_released("Sprint"):
			speed = GameManager.move
			is_sprinting = false
		
		if event.is_action_pressed("Gamepad Fire"):
			if joystick_target.position != Vector2.ZERO and !joystick_web_lock:
				print("pew pew")
				ShotWeb(joystick_target.global_position)
				joystick_web_lock = true
		if event.is_action_released("Gamepad Fire"):
			joystick_web_lock = false
		
		if event.is_action_released("Fire"):
			ShotWeb(get_global_mouse_position())
		
		if event.is_action_pressed("Cheat Level"):
			GameManager.XP(GameManager.level_threshold)
		

func ShotWeb(target : Vector2):
	if GameManager.stamina > GameManager.stamina_shot_cost:
		GameManager.Stamina(-GameManager.stamina_shot_cost)
		var direction = target - global_position
		var new_strand = GameManager.strand.instantiate()
		web.add_child(new_strand, true)
		#print("Drawing line from %s to %s" % [global_position, target])
		new_strand.Initialize(global_position, direction, navigation_node)
		strands.append(new_strand)
		new_strand.completed_firing.connect(EndStrand)
		if !navigation_node:
			new_strand.node_a.CreateIntersect(GetCurrentStrand())
		navigation_node = new_strand.node_a
	
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
	if area.collision_layer == 32:
		navigation_node = area
		print("Navigation located")

func on_nav_exited(area : Area2D):
	if area.collision_layer == 32:
		if navigation_node == area:
			navigation_node = null

func ChangeCurrentStrand(new_strand : Line2D):
	if is_instance_valid(current_strand):
		current_strand.broken.disconnect(SafePlace)
	current_strand = new_strand
	current_strand.broken.connect(SafePlace)

func SafePlace(check : Line2D):
	current_strand = GetCurrentStrand()
	
	if check == current_strand:
		var target : Vector2
		if current_strand.node_a.directions.size() <= 1:
			target = current_strand.node_b.global_position
		elif current_strand.node_b.directions.size() <= 1:
			target = current_strand.node_a.global_position
		else:
		# Get closer point
			if global_position.distance_squared_to(target_location) < global_position.distance_squared_to(start_location):
				target = target_location
			else:
				target = start_location
		
		# Animate to safety
		var tween = create_tween()
		tween.tween_property(self, "global_position", target, 0.25)
		lock_movement = true
		await get_tree().create_timer(0.3).timeout
		
		# Assign new movement variables
		current_strand = GetCurrentStrand()
		start_location = current_strand.node_a.global_position
		target_location = current_strand.node_b.global_position
		lock_movement = false

func GetCurrentStrand() -> Line2D:
	var stored = nav_controller.get_overlapping_areas()
	var overlaps : Array[Area2D]
	for i in stored:
		#print("Collision layer is %s" % i.collision_layer)
		if i.collision_layer == 4 or i.collision_layer == 16:
			overlaps.append(i)
	print("Returning %s" % overlaps[0].get_parent().name)
	return overlaps[0].get_parent()
