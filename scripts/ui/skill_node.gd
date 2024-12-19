extends Node2D
class_name PolygonButton

@export var tooltip : String = "Default Tooltip"
@export var point_threshold : int
@export var type : SkillManager.type
@export var secondary : SkillManager.type
@export var node_colors : Array[Polygon2D]
@export var area : Area2D
@export_group("Button Values")
@export var disabled : bool = false
@export var purchased : bool = false

var connections : Array[Line2D]
var connected_skills : Array[PolygonButton]
var is_hovered : bool = false

signal pressed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SkillManager.nodes.append(self)


func activate(_viewport : Node, event : InputEvent, _shape_idx : int):
	get_viewport().set_input_as_handled()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if !event.pressed:
			pressed.emit()
			purchase()


func purchase():
	if !purchased and !disabled:
		purchased = true
		SetColors()
		SkillManager.PurchaseSkill(self)


# For Mouse Input
func enter():
	is_hovered = true
	SetColors()
	SkillManager.ShowTooltip(self)
	
	for i in connections:
		i.Show()


# For Mouse Input
func exit():
	is_hovered = false
	SetColors()
	SkillManager.HideTooltip()
	
	for i in connections:
		i.Show()

# Callable for array checking
func IsUnlocked(target : PolygonButton):
	return target.purchased


func CheckUnlock() -> void:
	if disabled and connected_skills.any(IsUnlocked):
		if SkillManager.GetAttribute(type) >= point_threshold or SkillManager.GetAttribute(secondary) >= point_threshold:
			disabled = false
			SetColors()


# Sets the array of overlapping connection lines
func SetConnections() -> void:
	var overlaps = area.get_overlapping_areas()
	for i in overlaps:
		connections.append(i.get_parent())


# Sets the node references for the connected skills
func SetSkills() -> void:
	for i in connections:
		if i.skill_a:
			i.skill_a.connected_skills.append(self)
			connected_skills.append(i.skill_a)
			#i.skill_b = self
		#else:
			#i.skill_a = self

func SetColors() -> void:
	#print("Setting %s" % name)
	if disabled:
		node_colors[0].color = SkillManager.NODE_DEACTIVE
		node_colors[1].color = SkillManager.NODE_DEACTIVE
		self_modulate = SkillManager.NODE_DISABLED
	
	else:
		if purchased:
			self_modulate = SkillManager.NODE_ACTIVE
		elif is_hovered:
			self_modulate = SkillManager.NODE_HOVERED
		else:
			self_modulate = SkillManager.NODE_DEACTIVE
			
		if is_hovered or purchased:
			node_colors[0].color = SkillManager.GetColor(type, true)
			node_colors[1].color = SkillManager.GetColor(secondary, true)
		else:
			node_colors[0].color = SkillManager.GetColor(type, false)
			node_colors[1].color = SkillManager.GetColor(secondary, false)
