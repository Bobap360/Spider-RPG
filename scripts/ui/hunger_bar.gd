extends Control

@export var readout : Label
@export var bar : ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()
	GameManager.hunger_changed.connect(update)

func update():
	readout.text = "%1.0f/%s" % [GameManager.hunger, GameManager.hunger_max]
	bar.max_value = GameManager.hunger_max
	bar.value = GameManager.hunger
