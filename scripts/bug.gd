extends Node2D

@export var health : float = 100.0
@export var struggle_count : int = 5
@export var struggle_time : float = 10.0
@export var spawn_rate : float = 1.0
@export var value : float = 10

@export var indicator : Node2D
@export var collider : Area2D
@export var timer : Timer
@export var art : Sprite2D
@export var health_bar : ProgressBar
@export var struggle_bar : ProgressBar

var strand : Node2D
var caught = false
var spawning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	health_bar.visible = false
	struggle_bar.visible = false

func Spawning() -> void:
	#var step : float = 1.0/24.0
	#var i : float = 0
	#var delay = GameManager.spawn_time * spawn_rate
	#var increment = (indicator.scale.x - art.scale.x/2) * step / delay
	#print(increment)
	#
	#while i < delay:
		#indicator.scale -= Vector2(increment, increment)
		#i += step
		#timer.start(step)
		#await timer.timeout
	var tween = create_tween()
	tween.tween_property(indicator, "scale", art.scale/2, GameManager.spawn_time * spawn_rate)
	await tween.finished
	
	art.visible = true
	indicator.visible = false
	FlyThrough()

func Struggle():
	#for i in struggle_count:
		#print("Bug is struggling")
		## Animation here
		#timer.start(struggle_delay)
		#await timer.timeout
	struggle_bar.visible = true
	var struggle_anim = create_tween()
	var dist = 1.0
	var step = 0.25
	
	#var times : Array = []
	#var time_tracker = struggle_time
	#var time_step = 0.1
	#var new_time = 2.0
	#
	#while time_tracker > 0:
		#times.push_front(new_time)
		#new_time -= time_step
		#time_tracker -= new_time
	var delay = struggle_time * GameManager.struggle_mod
	for i in 20:
		dist += step
		
		struggle_anim.tween_property(art, "position", Vector2(randf_range(-dist, dist), randf_range(-dist, dist)), delay/20)
		
	var tween = create_tween()
	tween.tween_property(struggle_bar, "value", struggle_bar.max_value, delay)
	await tween.finished
	if caught:
		FlyAway()
		
		if is_instance_valid(strand):
			strand.Break()
		#print("Bug has broken free")

func CheckWeb() -> void:
	await get_tree().physics_frame
	
	if collider.has_overlapping_areas():
		var areas = collider.get_overlapping_areas()
		for i in areas:
			if i.has_meta("type"):
				if i.get_meta("type") == ("web"):
					#print("Caught Bug on %s" % i.get_parent())
					caught = true
					strand = i.get_parent()
					strand.bugs.append(self)
					return
					
	#print("Bug is FREE")

func FlyAway() -> void:
	if is_instance_valid(strand):
		strand.bugs.erase(self)
		
	caught = false
	health_bar.visible = false
	struggle_bar.visible = false
	
	var direction : Vector2 = Vector2(randi_range(-800, 800), -3000)
		
	var tween = create_tween()
	tween.tween_property(self, "position", direction, 6.0)
	await tween.finished
	queue_free()

func FlyThrough() -> void:
	var fade_in = create_tween()
	fade_in.tween_property(art, "self_modulate", Color(0.216, 0.216, 0.216, 1), 1.0)
	fade_in.parallel().tween_property(art, "scale", art.scale * 0.5, 1.0)
	await fade_in.finished
	fade_in.stop()
	
	# Appears behind spider now
	z_index = 40
	await CheckWeb()
	
	if !caught:
		# Appears behind web now
		z_index = -10
		var fade_out = create_tween()
		fade_out.tween_property(art, "self_modulate", Color(0.216, 0.216, 0.216, 0), 1.0)
		fade_out.parallel().tween_property(art, "scale", Vector2.ZERO, 1.0)
		await fade_out.finished
		queue_free()
	else:
		Struggle()
	
func Damage(amount : float):
	if caught:
		health_bar.visible = true
		
		health_bar.value -= amount
		
		if health_bar.value <= 0:
			health_bar.value = 0
			Kill()
		
		# Bar coloring logic
		if health_bar.value > health * 0.75:
			health_bar.self_modulate = Color(0.03, 0.526, 0, 1)
		elif health_bar.value > health * 0.33:
			health_bar.self_modulate = Color(0.816, 0.384, 0, 1)
		else:
			health_bar.self_modulate = Color(1, 0, 0.2, 1)
	
func Kill():
	GameManager.Score(value)
	GameManager.XP(value)
	GameManager.Hunger(value)
	strand.bugs.erase(self)
	# Death animation stuff here
	queue_free()

#func on_area_entered(area : Area2D):
	#if area.has_meta("type"):
		#if area.get_meta("type") == "web" and not caught:
			#caught = true
			#Struggle()
