extends Node2D

var moving = false
var path : PathFollow2D
var speed : float
var strands : Array[Line2D]
var bugs : Array[Node2D]
@export var web_strand : PackedScene
@export var web : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Path follow assignment
	#path = get_parent()
	speed = GameManager.move

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if strands.size() > 0:
		for i in strands:
			i.Firing()
	
	if bugs.size() > 0:
		for i in bugs:
			i.Damage(GameManager.strength)
	
	var movement_vector = Vector2(Input.get_axis("Move Left", "Move Right"), Input.get_axis("Move Up", "Move Down"))
	position += movement_vector * speed
	
	# Path follow movement-ish
	#if movement_vector.x > 0 and path:
		#path.progress += GameManager.move
	#if movement_vector.x < 0 and path:
		#path.progress -= GameManager.move

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Sprint"):
		speed = GameManager.sprint
		
	if event.is_action_released("Sprint"):
		speed = GameManager.move
		
	if event.is_action_released("Fire"):
		ShotWeb(get_global_mouse_position())

func ShotWeb(target : Vector2):
	var direction = target - global_position
	var new_strand = web_strand.instantiate()
	web.add_child(new_strand, true)
	#print("Drawing line from %s to %s" % [global_position, target])
	new_strand.Initialize(global_position, direction)
	strands.append(new_strand)
	new_strand.completed_firing.connect(EndStrand)

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
