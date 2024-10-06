extends Button

@export var t : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	if !disabled:
		t.visible = true


func _on_mouse_exited() -> void:
	t.visible = false


func _on_button_down() -> void:
	t.self_modulate = Color(1, 1, 1, 0.5)


func _on_button_up() -> void:
	t.self_modulate = Color(1, 1, 1, 1)
