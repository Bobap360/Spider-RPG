extends Node2D

@export_category("Behavior Values")

## How much damage this enemy can take before dying
@export var health : float = 100.0
## Amount of time in seconds the bug will be caught in the web
@export var struggle_time : float = 10.0
## Multiplier for indicator animation time
@export var spawn_rate : float = 1.0
## How much xp and hunger this enemy grants on death
@export var value : float = 10
@export var wiggle_strength : float = 1.0

@export_group("Node References")
@export var indicator : Node2D
@export var collider : Area2D
@export var art : Sprite2D
@export var anim : AnimatedSprite2D
@export var health_bar : ProgressBar
@export var struggle_bar : ProgressBar

var strand : Node2D
var caught = false
var spawning = false

signal got_caught()
signal freed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	health_bar.visible = false
	struggle_bar.visible = false
	
	if art:
		art.modulate.a = 0.0
	
	if anim:
		anim.modulate.a = 0.0
		anim.play("default")
	
	indicator.scale = indicator.scale * 4
	
	Spawning()

func Spawning() -> void:
	var rate = GameManager.spawn_time * spawn_rate
	var tween = create_tween()
	tween.tween_property(indicator, "scale", indicator.scale * 0.5, rate)
	tween.parallel().tween_property(indicator, "global_rotation", indicator.global_rotation + (0.8 * rate), rate)
	await tween.finished
	
	if anim:
		anim.visible = true
		
	indicator.visible = false
	FlyThrough()

func Wiggle():
	while caught:
		var tween = create_tween()
		
		if anim:
			tween.tween_property(anim, "position", Vector2(randf_range(-wiggle_strength, wiggle_strength), randf_range(-wiggle_strength, wiggle_strength)), 0.3)
		else:
			tween.tween_property(art, "position", Vector2(randf_range(-wiggle_strength, wiggle_strength), randf_range(-wiggle_strength, wiggle_strength)), 0.3)
		await tween.finished

func Struggle():
	struggle_bar.visible = true
	
	if anim:
		Transition()
		
	var struggle_anim = create_tween()
	var dist = 1.0
	var step = 0.25
	
	var delay = struggle_time * GameManager.struggle_mod
	for i in 20:
		dist += step
		
		if anim:
			struggle_anim.tween_property(anim, "position", Vector2(randf_range(-dist, dist), randf_range(-dist, dist)), delay/20)
			struggle_anim.parallel().tween_property(anim, "rotation_degrees", rotation_degrees + randf_range(-5, 5), delay/20)
		else:
			struggle_anim.tween_property(art, "position", Vector2(randf_range(-dist, dist), randf_range(-dist, dist)), delay/20)
			struggle_anim.parallel().tween_property(art, "rotation_degrees", rotation_degrees + randf_range(-5, 5), delay/20)
	
	var tween = create_tween()
	tween.tween_property(struggle_bar, "value", struggle_bar.max_value, delay)
	await tween.finished
	if caught:
		FlyAway()
		
		if is_instance_valid(strand):
			strand.Break()
		
		if anim:
			anim.play_backwards("transition")
			await anim.animation_finished
			anim.play("default", 1.0)
		#print("Bug has broken free")

func Transition():
	anim.play("transition", 1.0)
	await anim.animation_finished
	anim.play("caught", 1.0)

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
					got_caught.emit()
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
	var regular_size : Vector2
	if anim:
		regular_size = anim.scale
		anim.scale = anim.scale * 2
		fade_in.tween_property(anim, "modulate:a", 1.0, 1.0)
		fade_in.parallel().tween_property(anim, "scale", regular_size, 1.0)
	else:
		regular_size = art.scale
		art.scale = art.scale * 2
		fade_in.tween_property(art, "modulate:a", 1.0, 1.0)
		fade_in.parallel().tween_property(art, "scale", regular_size, 1.0)
		
	await fade_in.finished
	fade_in.stop()
	
	# Appears behind spider now
	z_index = 40
	await CheckWeb()
	
	if !caught:
		# Appears behind web now
		z_index = -10
		var fade_out = create_tween()
		
		if anim:
			fade_out.tween_property(anim, "self_modulate:a", 0.0, 1.0)
			fade_out.parallel().tween_property(anim, "scale", Vector2.ZERO, 1.0)
		else:
			fade_out.tween_property(art, "modulate:a", 0.0, 1.0)
			fade_out.parallel().tween_property(art, "scale", Vector2.ZERO, 1.0)
		
		await fade_out.finished
		queue_free()
		
	elif struggle_time > 0:
		Struggle()
		
	else: 
		Wiggle()
	
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
