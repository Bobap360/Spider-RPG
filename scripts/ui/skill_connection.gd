extends Line2D

@export var skill_a : PolygonButton
@export var skill_b : PolygonButton
@export var area : Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collider = $Area2D/CollisionShape2D
	collider.shape = SegmentShape2D.new()
	collider.shape.a = points[0]
	collider.shape.b = points[points.size()-1]
	SkillManager.connections.append(self)


func Show() -> void:
	if !(skill_a.disabled or skill_b.disabled):
		if skill_a.purchased and skill_b.purchased:
			self_modulate = SkillManager.NODE_ACTIVE
			
		elif (skill_a.is_hovered and skill_b.purchased) or (skill_b.is_hovered and skill_a.purchased):
			self_modulate = SkillManager.NODE_HOVERED

		elif skill_a.purchased or skill_b.purchased:
			self_modulate = SkillManager.NODE_DEACTIVE
		
	else:
		self_modulate = SkillManager.NODE_DISABLED


func CheckUnlocks() -> void:
	skill_a.CheckUnlock()
	skill_b.CheckUnlock()


func SetNodes() -> void:
	var overlaps = area.get_overlapping_areas()
	if overlaps.size() == 2:
		skill_a = overlaps[0].get_parent()
		skill_b = overlaps[1].get_parent()
	else:
		print("Error in overlaps for %s. There are %s connections" % [name, overlaps.size()])
