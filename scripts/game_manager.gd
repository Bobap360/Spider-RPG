extends Node2D

var hunger_max : float = 100.0
var hunger : float = 100.0
var hunger_drain_rate : float = 1.0

var stamina_max : float = 100.0
var stamina : float = 100.0
var stamina_shot_cost : float = 10.0
var stamina_regen : float = 1.0
var stamina_sprint_rate : float = 1.0

var score : int = 0
var move : float = 2.0
var sprint : float = 3.0
var web_speed : float = 1.0
var spawn_time : float = 3.0
var strength : float = 1.0

var is_paused : bool = false
var is_ended : bool = false

signal score_changed(amount : int)
signal hunger_changed()
signal stamina_changed()
signal game_ended()
signal game_started()
signal game_paused()
signal game_resumed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	is_ended = true
	print("You died")
	game_ended.emit()

func Quit():
	get_tree().quit()

func Stamina(amount : float):
	stamina += amount
	stamina_changed.emit()
	
	if stamina > stamina_max:
		stamina = stamina_max
	
	elif stamina < 0:
		stamina = 0

func Hunger(amount : float):
	hunger += amount
	hunger_changed.emit()
	
	if hunger > hunger_max:
		hunger = hunger_max
	elif hunger <= 0:
		hunger = 0
		End()
