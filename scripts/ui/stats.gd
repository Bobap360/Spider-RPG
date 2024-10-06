extends Control

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

func CheckButtons():
		if GameManager.attribute_points <= 0:
			for i in attribute_buttons:
				i.disabled = true
				i.t.visible = false
		else:
			for i in attribute_buttons:
				i.disabled = false

func Strength():
	GameManager.LevelStrength()

func Dex():
	GameManager.LevelDexterity()

func Intel():
	GameManager.LevelIntelligence()
