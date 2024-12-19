extends PanelContainer

@export var body : Label
@export var offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SkillManager.tooltip = self


func Show(target : PolygonButton) -> void:
	body.text = target.tooltip
	visible = true
	global_position = target.global_position + offset - Vector2(size.x / 2, size.y)


func Hide():
	visible = false
