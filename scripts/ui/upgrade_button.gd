extends Button

@export var t : Label
@export var tooltip : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
