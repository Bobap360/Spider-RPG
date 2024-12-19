extends Node2D

@export_category("Tool Button")
@export var color_nodes : bool = false : set = set_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_button(new_value: bool) -> void:
	print("Clicked button")
	for i in get_children():
		i.SetColors()

# INT skills
func gnat_value() -> void:
	pass

func warn_time() -> void:
	GameManager.spawn_time += 0.4

func break_time() -> void:
	GameManager.struggle_mod += 0.1

func time_hybrid() -> void:
	GameManager.spawn_time += 0.2
	GameManager.struggle_mod += 0.05

func web_width() -> void:
	pass

func break_protection() -> void:
	#50% chance for strand not to break on the first escape
	pass

func unlock_cocoon() -> void:
	pass

func cocoon_instant() -> void:
	pass

func cocoon_move() -> void:
	pass

func cocoon_xp() -> void:
	pass

func cocoon_hunger() -> void:
	pass

func cocoon_hybrid() -> void:
	pass

func xp_increase() -> void:
	GameManager.xp_bonus += 0.1

func unlock_moth() -> void:
	pass


# DEX skills
func max_stamina() -> void:
	GameManager.stamina_max += 25

func stamina_sprint_cost() -> void:
	GameManager.stamina_sprint_cost -= GameManager.sprint_cost_default * 0.1

func stamina_sprint_speed() -> void:
	# Sprint bonus is default 50%
	GameManager.sprint += 0.1

func stamina_regen() -> void:
	GameManager.stamina_regen += 0.125

func movespeed() -> void:
	GameManager.move += 0.1

func web_cost() -> void:
	# Default shot cost is 10.0
	GameManager.stamina_shot_cost -= 1.0

func web_speed() -> void:
	# Default web speed is 10 units
	GameManager.web_speed += 2.0

func jump_unlock() -> void:
	pass

func jump_cost() -> void:
	pass

func jump_speed() -> void:
	pass

func jump_hybrid() -> void:
	pass

func damselfly_unlock() -> void:
	pass


# STR skills
func max_hunger() -> void:
	GameManager.hunger_max += 25
	
func damage_increase() -> void:
	GameManager.damage_mod += 0.1
	
func hunger_drain_rate() -> void:
	GameManager.hunger_drain_rate -= 0.1
	
func hunger_gain() -> void:
	GameManager.hunger_gain_mod += 0.1

func charge_attack_unlock() -> void:
	pass

func charge_attack_cost() -> void:
	pass

func charge_attack_damage() -> void:
	pass

func charge_attack_hybrid() -> void:
	pass

func beetle_unlock() -> void:
	pass

func slow_break() -> void:
	GameManager.struggle_slow += 0.25

func multistrike() -> void:
	pass
