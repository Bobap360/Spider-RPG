extends Control

@export var bar : ProgressBar
@export var readout : Label
@export var level : Label

func _ready() -> void:
	bar.value = GameManager.xp
	bar.max_value = GameManager.level_thresholds[GameManager.level]
	level.text = "Level %s" % GameManager.level
	GameManager.xp_changed.connect(update)
	GameManager.leveled_up.connect(LevelUp)

func update(_amount : float):
	readout.text = "%s/%s" %[GameManager.xp, GameManager.level_thresholds[GameManager.level]]
	bar.value = GameManager.xp

func LevelUp():
	level.text = "Level %s" % GameManager.level
	bar.max_value = GameManager.level_thresholds[GameManager.level]
	update(0)
