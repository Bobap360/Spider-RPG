extends Control

@export var zoom_rate : float = 0.1
@export var zoom_max : float = 1.0
@export var zoom_min : float = 1.0
@export var body : Control
var is_dragging : bool = false
var focused : bool = false
var last_pos : Vector2 = Vector2.ZERO

var center_pos : Vector2
var x_limit_pos : float
var x_limit_neg : float
var y_limit_pos : float
var y_limit_neg : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_pos = get_parent().size/2
	get_limits()


func _unhandled_input(event: InputEvent) -> void:
	if focused:
		if event is InputEventMouseMotion and is_dragging:
			position += event.relative
			scroll_limit()
			#drag()
			
		if event is InputEventMouseButton:
			if event.pressed:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						last_pos = get_global_mouse_position()
						is_dragging = true
			
					MOUSE_BUTTON_WHEEL_UP :
						if scale.x < zoom_max:
							_zoom_at_point(1.0 + zoom_rate, get_viewport().get_mouse_position())
					
					MOUSE_BUTTON_WHEEL_DOWN:
						if scale.x > zoom_min:
							_zoom_at_point(1.0 - zoom_rate, get_viewport().get_mouse_position())
					
			elif event.is_released():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						is_dragging = false
			
			#get_viewport().set_input_as_handled()


func drag() -> void:
	var offset = get_global_mouse_position() - last_pos
	position += offset
	last_pos = get_global_mouse_position()


# Camera-based zoom function
#func set_zoom(delta: Vector2) -> void:
	#var mouse_pos := get_global_mouse_position()
	#camera.zoom += delta
	#var new_mouse_pos := get_global_mouse_position()
	#camera.position += mouse_pos - new_mouse_pos


func _zoom_at_point(zoom_change : float, mouse_position : Vector2):
	var new_scale = scale * zoom_change
	
	if new_scale.x > zoom_max:
		new_scale = Vector2(zoom_max, zoom_max)
		
	elif new_scale.x < zoom_min:
		new_scale = Vector2(zoom_min, zoom_min)
		
	zoom_change = new_scale.x/scale.x
	scale = new_scale
	var delta_x = (mouse_position.x - global_position.x) * (zoom_change - 1)
	var delta_y = (mouse_position.y - global_position.y) * (zoom_change - 1)
	global_position.x = global_position.x - delta_x
	global_position.y = global_position.y - delta_y
	
	get_limits()
	scroll_limit()


func entered() -> void:
	print("Entered skill tree")
	focused = true


func exited() -> void:
	print("Exited skill tree")
	focused = false
	is_dragging = false


func get_limits() -> void:
	var window_size : Vector2 = get_parent().size
	#x_limit_pos = (center_pos.x + (size.x/2)) * scale.x
	#x_limit_neg = (center_pos.x - (size.x/2)) * scale.x
	#y_limit_pos = (center_pos.y + (size.y/2)) * scale.y
	#y_limit_neg = (center_pos.y - (size.y/2)) * scale.y
	var dif : Vector2 = Vector2(abs((body.size.x * scale.x) - window_size.x), abs((body.size.y * scale.y) - window_size.y))
	x_limit_pos = center_pos.x + (dif.x / 2)
	x_limit_neg = center_pos.x - (dif.x / 2)
	y_limit_pos = center_pos.y + (dif.y / 2)
	y_limit_neg = center_pos.y - (dif.y / 2)

func scroll_limit() -> void:
	# X limit
	if position.x >= x_limit_pos:
		position.x = x_limit_pos
		
	elif position.x <= x_limit_neg:
		position.x = x_limit_neg
	
	# Y limit
	if position.y >= y_limit_pos:
		position.y = y_limit_pos
		
	elif position.y <= y_limit_neg:
		position.y = y_limit_neg
