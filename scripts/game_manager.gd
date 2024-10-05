extends Node2D

var hunger : float = 100.0
var stamina : float = 100.0
var score : int = 0
var move : float = 2.0
var sprint : float = 3.0
var web_speed : float = 1.0
var spawn_time : float = 5.0
var strength : float = 1.0

signal score_changed(amount : int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Score(amount : int):
	score += amount
	score_changed.emit(amount)
