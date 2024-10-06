extends Control

@export var bar : ProgressBar
@export var readout : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	GameManager.stamina_changed.connect(update)

func update():
	readout.text = "%1.0f/%s" % [GameManager.stamina, GameManager.stamina_max]
	bar.max_value = GameManager.stamina_max
	bar.value = GameManager.stamina
