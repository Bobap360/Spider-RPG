extends Node2D

@export var point_thresholds : Array[int]
@export var scale_thresholds : Array[float]
@export var type : SkillManager.type
var is_max : bool = false
var max_scale : float = 1.0
var min_scale : float = 0.235
var stat : int
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#GameManager.stats_changed.connect(AdjustScale)
	#scale = Vector2(min_scale, min_scale)
	#ring_interval = (max_scale - min_scale) / rings

func AdjustScale() -> void:
	stat = SkillManager.GetAttribute(type)
	# Check if we're below max thresholds still
	if point_thresholds.back() > stat and !is_max:
		var threshold : int
		var new_scale : float
		
		# Get the threshold tier we need
		for i in point_thresholds.size():
			if point_thresholds[i] >= stat:
				new_scale = scale_thresholds[i]
				threshold = point_thresholds[i]
				break
		
		# Scale calculates based on percentage distance to next tier
		new_scale -= min_scale
		new_scale = new_scale * (float(stat) / float(threshold))
		
		#Create the growing animation
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "scale", Vector2(new_scale + min_scale, new_scale + min_scale), 0.3)

	
	# Caps size
	elif !is_max:
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self,"scale", Vector2.ONE, 0.3)
		is_max = true
