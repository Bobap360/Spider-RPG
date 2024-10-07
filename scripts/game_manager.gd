extends Node2D

const strand : PackedScene = preload("res://fabs/strand.tscn")
const nav_node : PackedScene = preload("res://fabs/nav_node.tscn")

# Hunger
var hunger_max : float = 100.0
var hunger : float = 100.0
var hunger_drain_rate : float = 1.0
var hunger_gain_mod : float = 1.0

# Stamina
var stamina_max : float = 100.0
var stamina : float = 100.0
var stamina_shot_cost : float = 10.0
var stamina_regen : float = 1.0
var stamina_sprint_cost : float = 5.0

# Attributes
var strength : int = 0
var dex : int = 0
var intel : int = 0

# Stat values
var score : int = 0
var move : float = 2.0
var sprint : float = 3.0
var speed_mod : float = 1.0
var web_speed : float = 10.0
var spawn_time : float = 3.0
var damage : float = 50.0
var struggle_mod : float = 1.0

# Level tracking
var xp : int = 0
var xp_mod : float = 1.0
var level : int = 1
var attribute_points : int = 0
var level_threshold : int = 10

# Status bools
var is_max_level : bool = false
var is_paused : bool = false
var is_ended : bool = false
var intersections : Node2D
var web : Node2D

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
	pass # Replace with function body.

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
