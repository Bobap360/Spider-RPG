extends Button

@export var t : Label
@export var tooltip : Control
@export var description : String
@export var label_ref : Label
@export var type : SkillManager.type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.stats_changed.connect(UpdateText)
	UpdateText()

func _on_mouse_entered() -> void:
	if !disabled:
		t.visible = true
	tooltip.visible = true


func _on_mouse_exited() -> void:
	Hide()


func _on_button_down() -> void:
	t.self_modulate = Color(1, 1, 1, 0.5)


func _on_button_up() -> void:
	t.self_modulate = Color(1, 1, 1, 1)


func Hide():
	t.visible = false
	tooltip.visible = false

func UpdateText():
	var value : float
	
	match type:
		SkillManager.type.INT:
			value = int((GameManager.xp_mod - 1.0) * 100)
		SkillManager.type.DEX:
			value = int((GameManager.speed_mod - 1.0) * 100)
		SkillManager.type.STR:
			value = int((GameManager.damage_mod - 1.0) * 100)
		_:
			print("Invalid type allocation")
	
	label_ref.text = description.replace("%s", str(value))
