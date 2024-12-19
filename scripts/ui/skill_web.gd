extends Node2D

enum type {INT, DEX, STR}

const NODE_DISABLED = Color(0.137, 0.137, 0.137)
const NODE_ACTIVE = Color(0.882, 0.882, 0.882)
const NODE_DEACTIVE = Color(0.392, 0.392, 0.392)
const NODE_HOVERED = Color(0.65, 0.607, 0.361)

const INT_ACTIVE = Color(0.196, 0.349, 0.647)
const INT_DEACTIVE = Color(0.39, 0.477, 0.65)

const DEX_ACTIVE = Color(0.294, 0.659, 0.278)
const DEX_DEACTIVE = Color(0.484, 0.66, 0.475)

const STR_ACTIVE = Color(0.671, 0.18, 0.18)
const STR_DEACTIVE = Color(0.67, 0.422, 0.422)

const STAT_DISABLED = Color(0.588, 0.588, 0.588)

var tooltip : Control

var nodes : Array[PolygonButton]
var connections : Array[Line2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Needs to stall for physics update
	await get_tree().create_timer(0.01).timeout
	for i in nodes:
		i.SetConnections()
	for i in connections:
		i.SetNodes()
	for i in nodes:
		i.SetSkills()
		i.SetColors()


func CheckAll() -> void:
	for i in nodes:
		i.CheckUnlock()
	for i in connections:
		i.Show()


func ShowTooltip(target : PolygonButton):
	if tooltip:
		tooltip.Show(target)


func HideTooltip():
	if tooltip:
		tooltip.Hide()


func PurchaseSkill(target : PolygonButton):
	GameManager.attribute_points -= 1
	LevelAttribute(target.type)
	LevelAttribute(target.secondary)
	CheckAll()
	GameManager.stats_changed.emit()

func GetColor(node_type : type, is_active : bool) -> Color:
	match node_type:
		type.INT:
			if is_active:
				return INT_ACTIVE
			else:
				return INT_DEACTIVE
		
		type.DEX:
			if is_active:
				return DEX_ACTIVE
			else:
				return DEX_DEACTIVE
		
		type.STR:
			if is_active:
				return STR_ACTIVE
			else:
				return STR_DEACTIVE
		
		_:
			print("Problem assigning node color.")
			return NODE_DISABLED

func LevelAttribute(stat : type) -> void:
	match stat:
		type.INT:
			GameManager.intel += 1
			GameManager.total_attributes += 1
		
		type.DEX:
			GameManager.dex += 1
			GameManager.total_attributes += 1
		
		type.STR:
			GameManager.strength += 1
			GameManager.total_attributes += 1
		
		_:
			print("Bad stat allocation.")

func GetAttribute(stat : type) -> int:
	match stat:
		type.INT:
			return GameManager.intel
		
		type.DEX:
			return GameManager.dex
		
		type.STR:
			return GameManager.strength
		
		_:
			print("Bad stat get reference.")
			return -1

#func SetNodeRing(target : PolygonButton) -> void:
	#if target.disabled:
		#target.node_colors[0].color = NODE_DEACTIVE
		#target.node_colors[1].color = NODE_DEACTIVE
		#target.self_modulate = NODE_DISABLED
	#
	#else:
		#if target.purchased:
			#target.self_modulate = NODE_ACTIVE
		#elif target.is_hovered:
			#target.self_modulate = NODE_HOVERED
		#else:
			#target.self_modulate = NODE_DEACTIVE


#func Coloring(target : PolygonButton):
		#match target.type:
			#type.INT:
				#if target.is_hovered or target.purchased:
					#target.bg.color = INT_ACTIVE
				#else:
					#target.bg.color = INT_DEACTIVE
			#
			#type.DEX:
				#if target.is_hovered or target.purchased:
					#target.bg.color = DEX_ACTIVE
				#else:
					#target.bg.color = DEX_DEACTIVE
			#
			#type.STR:
				#if target.is_hovered or target.purchased:
					#target.bg.color = STR_ACTIVE
				#else:
					#target.bg.color = STR_DEACTIVE
			#
			#_:
				#target.bg.color = NODE_DISABLED
				#print("Problem assigning node color.")
