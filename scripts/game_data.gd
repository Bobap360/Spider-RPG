extends Node2D

var data = ConfigFile.new()
var settings = ConfigFile.new()

func _ready() -> void:
	Load()

func Save():
	SetData()
	data.save("user://data.cfg")

func Load():
	var err = data.load("user://data.cfg")
	
	if err != OK:
		printerr("Load Failed")
		DefaultData()
	else:
		GetData()

# Creates a new save file
func DefaultData():
	print("Creating new save data")
	data.set_value("Player", "Hunger", 100.0)
	data.set_value("Player", "Stamina", 100.0)
	data.set_value("Player", "Score", 0.0)
	data.set_value("Player", "Move", 0.0)
	data.set_value("Player", "Sprint", 0.0)

# Used to load
func GetData() -> void:
	GameManager.hunger = data.get_value("Player", "Hunger")
	GameManager.stamina = data.get_value("Player", "Stamina")
	GameManager.score = data.get_value("Player", "Score")
	GameManager.move = data.get_value("Player", "Move")
	GameManager.sprint = data.get_value("Player", "Sprint")

# Used to save
func SetData() -> void:
	data.set_value("Player", "Hunger", GameManager.hunger)
	data.set_value("Player", "Stamina", GameManager.stamina)
	data.get_value("Player", "Score", GameManager.score)
	data.get_value("Player", "Move", GameManager.move)
	data.get_value("Player", "Sprint", GameManager.sprint)

# Returns settings to default
func DefaultSettings() -> void:
	settings.set_value("Volume", "Master", 0.2)
	settings.set_value("Volume", "Effects", 1.0)
	settings.set_value("Volume", "Music", 1.0)
