extends Node2D

enum BUG {FLY, HORSEFLY, DRAGONFLY, BEE, BUTTERFLY, MOTH, FAERIE}

@export var delay : float = 5.0
@export var gnat_spawnrate : float = 3.0
var radius : float = 10
@export var timer : Timer
@export var timer_gnat : Timer
@export var bug : PackedScene
@export var container : Node2D
var spawning : bool = true
var spawning_gnats : bool = true

@export var bug_table : LootTable
@export var gnat_fab : PackedScene

const tables : Array[LootTable] = [
preload("res://resources/bug_table_01.tres"),
preload("res://resources/bug_table_05.tres"),
]

func _ready() -> void:
	#var new_table = bug_table
	#new_table.Seed()
	#new_table.ShowPercentages()
	#bug_table = null
	#bug_table = new_table
	bug_table.Seed()
	#bug_table.ShowPercentages()
	GameManager.leveled_up.connect(UpdateTable)
	#ResourceLoader.load(bug_table.get_path(), "", 2)
	
	radius = $CollisionShape2D.shape.radius
	Cycle()
	Gnats()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Spawn Bug"):
		Spawn(get_global_mouse_position())
	if event.is_action_pressed("Test Input"):
		if bug_table:
			bug_table.Add(bug)
			bug_table.Populate()
			bug_table.ShowPercentages()

func Spawn(new_pos : Vector2):
	if bug_table:
		var new_bug = bug_table.Select().drop.instantiate()
		container.add_child(new_bug)
		new_bug.position = new_pos
		#new_bug.Spawning()

func Gnats() -> void:
	await timer.timeout
	
	while spawning_gnats and !GameManager.is_ended:
		var new_gnat = gnat_fab.instantiate()
		container.add_child(new_gnat)
		new_gnat.position = PickRandomLocation()
		timer_gnat.start(gnat_spawnrate * randf_range(0.8, 1.2))
		await timer_gnat.timeout

func Cycle():
	timer.start(delay)
	await timer.timeout
	
	while spawning and !GameManager.is_ended:
		Spawn(PickRandomLocation())
		#print("Bug Location is at %s" % new_pos)
		timer.start(delay)
		await timer.timeout

# Distribution weighted toward center
func ChooseRandomLocation() -> Vector2:
	var angle = randf_range(0, TAU)
	var distance = randf_range(0, 478)
	var x = global_position.x + cos(angle) * distance
	var y = global_position.y + sin(angle) * distance
	return Vector2(x,y)

# Even distribution algorithm
func PickRandomLocation() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf()) * radius + global_position

func UpdateTable() -> void:
	var lvl = GameManager.level
	var old_table = bug_table
	
	if lvl == 60:
		pass
	if lvl >= 5:
		bug_table = tables[1]
	else: 
		bug_table = tables[0]
	
	if bug_table != old_table:
		bug_table.Seed()
		#bug_table.ShowPercentages()
		print("Assigning a new table: %s" % bug_table.resource_name)
