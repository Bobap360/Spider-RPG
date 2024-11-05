extends Resource

class_name Loot

# Used to for developer reference
@export var percent_chance : float : set = set_percent
@export var name : String
@export var drop : PackedScene
@export var weight : int

@export_group("Weights")
# Assigned by the drop table
@export var weight_from : int = 0
@export var weight_to : int = 0
# Multiplier for dynamically adjusting weight
@export var weight_mod : float = 1.0

func set_init(new_drop : PackedScene, new_name : String, new_weight : int) -> void:
	drop = new_drop
	name = new_name
	weight = new_weight
	emit_changed()

func set_percent(amount : float) -> void:
	percent_chance = amount
	emit_changed()

#func _init() -> void:
	#if !weight or weight <= 0:
		#printerr("%s does not have a valid weight assigned." % self.name)
