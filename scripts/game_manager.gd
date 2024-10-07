extends Node2D

const strand : PackedScene = preload("res://fabs/strand.tscn")
const nav_node : PackedScene = preload("res://fabs/nav_node.tscn")
const post : PackedScene = preload("res://fabs/strand_hidden.tscn")

# Defaults
const hunger_default : float = 100.0
const stamina_default : float = 100.0
const shot_cost_default : float = 10.0
const damage_default : float = 50.0
const sprint_default : float = 3.0
const move_default : float = 2.0
const warning_default : float = 3.0
const hunger_drain_default : float = 1.0
const stamina_regen_default : float = 1.0
const sprint_cost_default : float = 5.0
const first_level_threshold : int = 10

# Hunger
var hunger_max : float
var hunger : float
var hunger_drain_rate : float
var hunger_gain_mod : float

# Stamina
var stamina_max : float
var stamina : float
var stamina_shot_cost : float
var stamina_regen : float
var stamina_sprint_cost : float

# Attributes
var strength : int
var dex : int
var intel : int

# Stat values
var score : int
var move : float
var sprint : float
var speed_mod : float
var web_speed : float = 10.0
var spawn_time : float
var damage : float
var struggle_mod : float

# Level tracking
var xp : int
var xp_mod : float
var level : int
var attribute_points : int
var level_threshold : int

# Status bools
var is_max_level : bool
var is_paused : bool
var is_ended : bool
var intersections : Node2D
var web : Node2D
var controller : Node2D

# Signals
signal score_changed(amount : int)
signal stats_changed()
signal hunger_changed()
signal stamina_changed()
signal xp_changed(amount : int)
signal leveled_up()
signal game_ended()
signal game_started()
signal game_paused()
signal game_resumed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Reset()

func Reset():
	# Attributes
	level = 0
	level_threshold = first_level_threshold
	attribute_points = 0
	strength = 0
	dex = 0
	intel = 0
	xp = 0
	
	# Stats
	score = 0
	# Hunger
	hunger_max = hunger_default
	hunger = hunger_default
	hunger_drain_rate = hunger_drain_default
	# Stam
	stamina_max = stamina_default
	stamina = stamina_default
	stamina_shot_cost = shot_cost_default
	stamina_regen = stamina_regen_default
	stamina_sprint_cost = sprint_cost_default
	# Other
	damage = damage_default
	move = move_default
	sprint = sprint_default
	spawn_time = warning_default
	
	# Bools
	is_max_level = false
	is_paused = false
	is_ended = false
	
	# Mods
	xp_mod = 1.0
	speed_mod = 1.0
	struggle_mod = 1.0
	hunger_gain_mod = 1.0

func Score(amount : int):
	score += amount
	score_changed.emit(amount)

func Start():
	game_started.emit()

func Resume():
	get_tree().paused = false
	is_paused = false
	game_resumed.emit()

func Pause():
	get_tree().paused = true
	is_paused = true
	game_paused.emit()

func End():
	if !is_ended:
		is_ended = true
		print("You died")
	game_ended.emit()

func Quit():
	get_tree().quit()

func XP(amount : int):
	if level <= 60:
		xp += amount * xp_mod
		
		if xp >= level_threshold:
			if level < 60:
				xp -= level_threshold
				attribute_points += 1
				level += 1
				level_threshold += 10
				leveled_up.emit()
				#xp_changed.emit(level_threshold - 10)
				stats_changed.emit()
			elif !is_max_level:
				is_max_level = true
				attribute_points += 1
				stats_changed.emit()
		
		xp_changed.emit(amount * xp_mod)

func Stamina(amount : float):
	stamina += amount
	stamina_changed.emit()
	
	if stamina > stamina_max:
		stamina = stamina_max
	
	elif stamina < 0:
		stamina = 0

func Hunger(amount : float):
	hunger += amount * hunger_gain_mod
	hunger_changed.emit()
	
	if hunger > hunger_max:
		hunger = hunger_max
	elif hunger <= 0:
		hunger = 0
		End()

func LevelStrength():
	attribute_points -= 1
	strength += 1
	damage += 5
	hunger_max += 10
	stats_changed.emit()

func LevelDexterity():
	attribute_points -= 1
	dex += 1
	speed_mod += 0.05
	stamina_max += 10
	stats_changed.emit()
	
func LevelIntelligence():
	attribute_points -= 1
	intel += 1
	spawn_time += 0.15
	struggle_mod += 0.05
	stats_changed.emit()

func NewStrand() -> Line2D:
	var new_strand = strand.instantiate()
	web.add_child(new_strand, true)
	return new_strand

func NewPost() -> Line2D:
	var new_post = post.instantiate()
	web.add_child(new_post, true)
	return new_post
