extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = GameManager.hunger
	max_value = GameManager.hunger_max
	GameManager.hunger_changed.connect(update)

func update():
	value = GameManager.hunger
