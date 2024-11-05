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

var attributes : Dictionary = {
		"STR" : GameManager.strength,
		"DEX" : GameManager.dex,
		"INT" : GameManager.intel
		}
var primary : String
var secondary : String
var tertiary : String

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

func SortAttributes():
	attributes = {
		"STR" : GameManager.strength,
		"DEX" : GameManager.dex,
		"INT" : GameManager.intel
		}
	primary = "STR"
	
	if attributes["DEX"] > attributes[primary]:
		secondary = primary
		primary = "DEX"
	else:
		secondary = "DEX"
		
	if attributes["INT"] > attributes[primary]:
		tertiary = secondary
		secondary = primary
		primary = "INT"
	elif attributes["INT"] > attributes[secondary]:
		tertiary = secondary
		secondary = "INT"
	else:
		tertiary = "INT"

func GetClass():
	SortAttributes()
	var new_class : String = ""
	
	# Check the gap and total level are large enough to warrant a new class title
	if attributes[primary] - attributes[secondary] < 2 or attributes[primary] < 5:
		# Default build (All stats within 2 points of each other)
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
	else:
		match primary:
			"STR": # Strength build
				new_class += Prefix()
				
				if GameManager.strength >= 10:
					new_class += "RECLUSE"
				else:
					new_class += "WIDOW"
				#print("Build is Str heavy by %s" % max_dif)
				
			"DEX": # Dex build
				new_class += Prefix()
				
				if GameManager.dex >= 10:
					new_class += "HUNTSMAN"
				else:
					new_class += "WOLF"
				#print("Build is Dex heavy by %s" % max_dif)
				
			"INT": # Int build
				new_class += Prefix()
						
				if GameManager.intel >= 10:
					new_class += "WEAVER"
				else:
					new_class += "TANGLE"
				
				#print("Build is Int heavy by %s" % max_dif)
				
			_: # Error
				printerr("Something went wrong with class check")
		
	spider_class.text = new_class

func Prefix() -> String:
	#print("Secondary stat at: %s" % at)
	if attributes[secondary] >= 5:
		if attributes[secondary] - attributes[tertiary] < 2:
			return "PROFICIENT "
		
		else:
			match secondary:
				"STR":
					if GameManager.strength >= 10:
						return "DEADLY "
					return "STRONG "
				
				"DEX":
					if GameManager.dex >= 10:
						return "SWIFT "
					return "QUICK "
				
				"INT":
					if GameManager.intel >= 10:
						return "BRILLIANT "
					return "CLEVER "
				
				_:
					return "PREFIX ERROR"
	return ""

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
