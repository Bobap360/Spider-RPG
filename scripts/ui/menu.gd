extends Control

@export var fade : Control

@export var game_over_screen : Control
@export var black_screen : Control
@export var taunt : Control
@export var end_buttons : Control
@export var dead_spider : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_ended.connect(YouDied)
	position = Vector2(get_viewport().size.x/2, -1000)
	fade.self_modulate = Color(1,1,1,0)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Menu"):
		if GameManager.is_paused:
			Hide()
		else:
			Show()

func Show():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(get_viewport().size.x/2, get_viewport().size.y/2), 0.3)
	tween.parallel().tween_property(fade, "self_modulate", Color(1, 1, 1, 1), 0.3)
	GameManager.Pause()
	
func Hide():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(get_viewport().size.x/2, -1000), 0.3)
	tween.parallel().tween_property(fade, "self_modulate", Color(1, 1, 1, 0), 0.3)
	GameManager.Resume()

func Quit():
	GameManager.Quit()

func Reload():
	get_tree().reload_current_scene()

func PostGame():
	var tween = create_tween()
	
	tween.tween_property(dead_spider, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.parallel().tween_property(end_buttons, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.parallel().tween_property(taunt, "modulate", Color(1, 1, 1, 0), 0.5)
	tween.tween_property(black_screen, "modulate", Color(1, 1, 1, 0), 2.5)
	await tween.finished
	game_over_screen.visible = false

func YouDied():
	game_over_screen.visible = true
	game_over_screen.modulate = Color(1, 1, 1, 1)
	black_screen.modulate = Color(1, 1, 1, 0)
	dead_spider.modulate = Color(1, 1, 1, 0)
	taunt.modulate = Color(1, 1, 1, 0)
	end_buttons.modulate = Color(1, 1, 1, 0)
	
	var tween = create_tween()
	tween.tween_property(taunt, "modulate", Color(1, 1, 1, 1), 1.5)
	tween.parallel().tween_property(black_screen, "modulate", Color(1, 1, 1, 0.5), 0.75)
	await get_tree().create_timer(4.0).timeout
	tween = create_tween()
	tween.tween_property(black_screen, "modulate", Color(1, 1, 1, 1), 2.0)
	await get_tree().create_timer(3.0).timeout
	tween = create_tween()
	tween.tween_property(end_buttons, "modulate", Color(1, 1, 1, 1), 1.0)
	tween.tween_property(dead_spider, "modulate", Color(1, 1, 1, 1), 2.0)
	
	
