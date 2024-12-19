extends Node2D

@export var point_thresholds : Array[int]
@export var scale_thresholds : Array[float]
@export var slices : Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.stats_changed.connect(AdjustScales)

func AdjustScales() -> void:
	for i in slices:
		i.AdjustScale()
