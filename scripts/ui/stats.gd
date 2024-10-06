extends Control

@export var spider_class : Label
@export var strength : Label
@export var dex : Label
@export var intel : Label
@export var attribute_points : Label
@export var attribute_buttons: Array[Button]

@export var damage : Label
@export var speed : Label
@export var web_cost : Label
@export var sprint_cost : Label
@export var stam_regen : Label
@export var warning_time : Label
@export var struggle_time : Label
@export var hunger_drain : Label
@export var xp_gain : Label
@export var hunger_restored : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UpdateAll()
	CheckButtons()
	GameManager.stats_changed.connect(UpdateAll)


func UpdateAll():
	strength.text = "STR\n%s" % GameManager.strength
	dex.text = "DEX\n%s" % GameManager.dex
	intel.text = "INT\n%s" % GameManager.intel
	
	attribute_points.text = "POINTS: %s" % GameManager.attribute_points
	
	damage.text = str(GameManager.damage)
	speed.text = str(GameManager.speed_mod * 100.0)
	web_cost.text = str(GameManager.stamina_shot_cost)
	sprint_cost.text = str(GameManager.stamina_sprint_cost)
	stam_regen.text = str(GameManager.stamina_regen)
	warning_time.text = str(GameManager.spawn_time)
	struggle_time.text = str(GameManager.struggle_mod * 100.0)
	hunger_drain.text = str(GameManager.hunger_drain_rate)
	xp_gain.text = str(GameManager.xp_mod * 100.0)
	hunger_restored.text = str(GameManager.hunger_gain_mod * 100.0)
	CheckButtons()
	GetClass()


func GetClass():
	var attributes : Array = [GameManager.strength, GameManager.dex, GameManager.intel]
	var which : int = 0
	var highest : int = 0
	
	for i in attributes.size():
		if attributes[i] > highest:
			highest = attributes[i]
			which = i
	
	if highest < 5:
		which = -1
		
	var diffs : Array[int] 
	for i in attributes.size():
		if i != which:
			diffs.append(highest - attributes[i])
	var max_dif : int = diffs.min()
	
	if max_dif == 0:
		which = -1
	
	var new_class : String = ""
	
	match which:
		-1: # Default build
			var i = GameManager.strength + GameManager.dex + GameManager.intel
			if i >= 60:
				new_class += "THE MANY-LEGGED ONE"
				
			elif i >= 40:
				new_class += "GIGANTULA"
				
			elif i >= 20:
				new_class += "PROFICIENT SPIDER"
			
			elif i >= 10:
				new_class += "INDECISIVE SPIDER"
				 
			else:
				new_class += "SPIDER"
			#print("Diffs less than 2")
			
		0: # Strength build
			if GameManager.intel > GameManager.dex:
				if GameManager.strength >= 10:
					new_class += "BRILLIANT "
				elif GameManager.strength >= 5:
					new_class += "CLEVER "
					
			elif GameManager.intel == GameManager.dex:
				if GameManager.intel >= 5:
					new_class += "PROFICIENT "
				
			else:
				if GameManager.dex >= 10:
					new_class += "SWIFT "
				elif GameManager.dex >= 5:
					new_class += "QUICK "
			
			if GameManager.strength >= 10:
				new_class += "RECLUSE"
			else:
				new_class += "WIDOW"
			#print("Build is Str heavy by %s" % max_dif)
			
		1: # Dex build
			if GameManager.strength > GameManager.intel:
				if GameManager.strength >= 10:
					new_class += "DEADLY "
				elif GameManager.strength >= 5:
					new_class += "STRONG "
			
			elif GameManager.strength == GameManager.intel:
				if GameManager.strength >= 5:
					new_class += "PROFICIENT "
			
			else:
				if GameManager.intel >= 10:
					new_class += "BRILLIANT "
				elif GameManager.intel >= 5:
					new_class += "CLEVER "
			
			if GameManager.dex >= 10:
				new_class += "HUNTSMAN"
			else:
				new_class += "WOLF"
			#print("Build is Dex heavy by %s" % max_dif)
			
		2: # Int build
			if GameManager.strength > GameManager.dex:
				if GameManager.strength >= 10:
					new_class += "DEADLY "
				elif GameManager.strength >= 5:
					new_class += "STRONG "
			
			elif GameManager.strength == GameManager.dex:
				if GameManager.strength >= 5:
					new_class += "PROFICIENT "
			
			else:
				if GameManager.dex >= 10:
					new_class += "SWIFT "
				elif GameManager.dex >= 5:
					new_class += "QUICK "
					
			if GameManager.intel >= 10:
				new_class += "WEAVER"
			else:
				new_class += "TANGLE"
			
			#print("Build is Int heavy by %s" % max_dif)
			
		_: # Error
			printerr("Something went wrong with class check")
		
	spider_class.text = new_class

func CheckButtons():
	var attributes : Array = [GameManager.strength, GameManager.dex, GameManager.intel]
	
	if GameManager.attribute_points <= 0:
		for i in attribute_buttons:
			i.disabled = true
			i.Hide()
	else:
		for i in attribute_buttons.size():
			if attributes[i] >= 20:
				attribute_buttons[i].disabled = true
				attribute_buttons[i].Hide()
			else:
				attribute_buttons[i].disabled = false


func Strength():
	GameManager.LevelStrength()


func Dex():
	GameManager.LevelDexterity()


func Intel():
	GameManager.LevelIntelligence()
