@tool
extends Control

@export var skill_node_container : Node2D
@export var connection_container : Node2D

@export_category("Web Tools")
@export var set_colors : bool = false : set = setting_colors


func setting_colors(new_value: bool) -> void:
	for i in skill_node_container.get_children():
		i.node_colors[0].color = get_color(i.type)
		i.node_colors[1].color = get_color(i.secondary)


func get_color(node_type : SkillManager.type) -> Color:
	#print("Getting Colors")
	match node_type:
		SkillManager.type.INT:
			return SkillManager.INT_ACTIVE
		
		SkillManager.type.DEX:
			return SkillManager.DEX_ACTIVE
		
		SkillManager.type.STR:
			return SkillManager.STR_ACTIVE
		
		_:
			print("Problem assigning node color.")
			return SkillManager.NODE_DEACTIVE


#@export var get_elements : bool = false : set = getting_elements
#@export var build_web : bool = false : set = update_all

#var nodes : Array[Node]
#var connections : Array[Node]
#
#
#func getting_elements(new_value : bool) -> void:
	#print("Getting Elements")
	#nodes = skill_node_container.get_children()
	#connections = connection_container.get_children()


#func update_all(new_value : bool) -> void:
	#for i in nodes:
		#set_connections(i)
	#for i in connections:
		#set_node_references(i)
	#for i in nodes:
		#set_node_to_node(i)
#
#
#func set_connections(target : PolygonButton) -> void:
	#var overlaps = target.area.get_overlapping_areas()
	#for i in overlaps:
		#target.connections.append(i.get_parent())
#
#
#func set_node_references(target : Line2D) -> void:
	#var overlaps = target.area.get_overlapping_areas()
	#if overlaps.size() == 2:
		#target.skill_a = overlaps[0].get_parent()
		#target.skill_b = overlaps[1].get_parent()
	#else:
		#print("Error in overlaps for %s. There are %s connections" % [name, overlaps.size()])
#
#
#func set_node_to_node(target : PolygonButton) -> void:
	#for i in target.connections:
		#if i.skill_a:
			#i.skill_a.connected_skills.append(self)
			#target.connected_skills.append(target.skill_a)
