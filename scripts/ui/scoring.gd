extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(GameManager.score)
	GameManager.score_changed.connect(update)

func update(_amount : int) -> void:
	text = str(GameManager.score)
