extends Node2D

@export var delay : float = 5.0
var radius : float = 10
@export var timer : Timer
@export var bug : PackedScene
@export var container : Node2D
var spawning : bool = true

func _ready() -> void:
	radius = $CollisionShape2D.shape.radius
	Cycle()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Spawn Bug"):
		Spawn(get_global_mouse_position())

func Spawn(new_pos : Vector2):
	var new_bug = bug.instantiate()
	container.add_child(new_bug)
	new_bug.position = new_pos
	new_bug.Spawning()

func Cycle():
	while spawning and !GameManager.is_ended:
		Spawn(PickRandomLocation())
		#print("Bug Location is at %s" % new_pos)
		timer.start(delay)
		await timer.timeout

func ChooseRandomLocation() -> Vector2:
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, 478)
	var x = global_position.x + cos(angle) * distance
	var y = global_position.y + sin(angle) * distance
	return Vector2(x,y)

func PickRandomLocation() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf()) * radius + global_position
