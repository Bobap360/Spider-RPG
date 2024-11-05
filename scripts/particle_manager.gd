extends Node2D

@export var web_debris : Array[CPUParticles2D]
var web_i : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.particle_manager = self

func PlayWebDebris(new_pos : Vector2, new_size : float, new_rot : float):
	var this = web_debris[web_i]
	
	this.global_position = new_pos
	this.global_rotation = new_rot
	this.emission_rect_extents = Vector2(new_size/2, 1)
	
	this.angle_min = -this.rotation_degrees - 25
	this.angle_max = -this.rotation_degrees + 25
	
	var new_amount : int = new_size/40
	if new_amount <= 0:
		new_amount = 2
	this.amount = new_amount
	
	this.restart()
	
	web_i += 1
	
	if web_i > web_debris.size() - 1:
		web_i = 0
