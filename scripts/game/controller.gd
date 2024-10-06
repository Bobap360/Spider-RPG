extends Node2D

var moving = false
var path : PathFollow2D
var speed : float
var strands : Array[Line2D]
var bugs : Array[Node2D]
var is_sprinting : bool = false
@export var web_strand : PackedScene
@export var web : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Path follow assignment
	#path = get_parent()
	speed = GameManager.move

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
				
		position += movement_vector * speed * GameManager.speed_mod
		
		# Path follow movement-ish
		#if movement_vector.x > 0 and path:
			#path.progress += GameManager.move
		#if movement_vector.x < 0 and path:
			#path.progress -= GameManager.move

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Sprint"):
		speed = GameManager.sprint
		is_sprinting = true
		
	if event.is_action_released("Sprint"):
		speed = GameManager.move
		is_sprinting = false
		
	if event.is_action_released("Fire"):
		ShotWeb(get_global_mouse_position())
		

func ShotWeb(target : Vector2):
	if GameManager.stamina > GameManager.stamina_shot_cost:
		GameManager.Stamina(-GameManager.stamina_shot_cost)
		var direction = target - global_position
		var new_strand = web_strand.instantiate()
		web.add_child(new_strand, true)
		#print("Drawing line from %s to %s" % [global_position, target])
		new_strand.Initialize(global_position, direction)
		strands.append(new_strand)
		new_strand.completed_firing.connect(EndStrand)
	
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
