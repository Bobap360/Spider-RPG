@tool

extends Resource

class_name LootTable

var default_table : Array[Loot]
@export var table : Array[Loot]
var total_weight : int

@export_category("Tool Button")
@export var calculate_values : bool = false : set = set_button

func set_button(new_value: bool) -> void:
	Seed()

func Seed() -> void:
	default_table.assign(table)
	Populate()
	#emit_changed()
	#take_over_path(get_path())
	#notify_property_list_changed()

# Assign default values
func Reset() -> void:
	table.assign(default_table)
	#emit_changed()
	#take_over_path(get_path())

# Increases weighting by a value of 1x, adds a new entry if not already present
func Add(element : PackedScene) -> void:
	#var i = table.find(element)
	#
	#if i >= 0:
		#table[i].weight_mod += 1.0
	var x = Check(element)
	if x >= 0:
		table[x].weight_mod += 1.0
	else:
		var loot = Loot.new()
		loot.set_init(element, element.get_path(), 50)
		table.append(loot)
	
func Check(element : PackedScene) -> int:
	for i in table.size():
		print("Checking %s against %s" % [table[i].drop, element])
		if table[i].drop == element:
			return i
	return -1

# Reduces weighting by a value of 1x, removes completely if reduced below 0
func Remove(element : Loot) -> void:
	var i = table.find(element)
	
	if i >= 0:
		table[i].weight_mod -= 1.0
		
		if table[i].weight <= 0:
			table.remove_at(i)
			
	else:
		printerr("%s doesn't exist in %s." % [element.name, resource_name])

# Redistributes weight values
func Populate() -> void:
	if table.size() > 0:
		total_weight = 0
		
		for i in table:
			if i.weight > 0:
				i.weight_from = total_weight
				total_weight += i.weight * i.weight_mod
				i.weight_to = total_weight
			else:
				printerr("%s has an invalid weight in %s." % [i.name, resource_name])
		
		for i in table:
			i.percent_chance = float(i.weight * i.weight_mod)/float(total_weight) * 100.0
	
	else:
		printerr("Cannot populate; %s is empty." % resource_name)

# Returns a randomly selected object from the table
func Select() -> Loot:
	if table.size() > 0:
		var hit = randi_range(0, total_weight - 1)
		
		for i in table:
			if hit >= i.weight_from and hit < i.weight_to:
				return i
		
		printerr("No loot found in %s for weight of %s." % [resource_name, hit])
		return table[0]
	
	else:
		printerr("%s is empty." % resource_name)
		return null

func ShowPercentages() -> void:
	print("Percentage distribution for %s" % resource_name)
	for i in table:
		print("%s%% : %s" % [i.percent_chance, i.name])
	print(" ")
