extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = GameManager.stamina
	max_value = GameManager.stamina_max
	GameManager.stamina_changed.connect(update)

func update():
	value = GameManager.stamina
